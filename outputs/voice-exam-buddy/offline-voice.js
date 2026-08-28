let offlineRecorder, offlineStream, offlineChunks=[];
const mic=$('#micButton'), micLabel=$('.mic-label');

async function transcribeRecording(blob){
  $('#voiceStatus').textContent='Transcribing on this device…';
  const audio=await new Promise((resolve,reject)=>{const reader=new FileReader();reader.onload=()=>resolve(reader.result);reader.onerror=reject;reader.readAsDataURL(blob)});
  const response=await fetch('/api/transcribe',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({audio,language:$('#language').value})});
  const data=await response.json();
  if(!response.ok)throw new Error(data.error||'Offline transcription failed.');
  if(!data.text)throw new Error('No speech was detected. Please try again.');
  $('#question').value=data.text;
  $('#voiceStatus').textContent='Offline transcription complete.';
  serveLesson();
}

mic.onclick=async()=>{
  if(offlineRecorder?.state==='recording'){
    mic.disabled=true;micLabel.textContent='Transcribing…';offlineRecorder.stop();return;
  }
  try{
    offlineStream=await navigator.mediaDevices.getUserMedia({audio:true});
    offlineChunks=[];
    offlineRecorder=new MediaRecorder(offlineStream);
    offlineRecorder.ondataavailable=e=>{if(e.data.size)offlineChunks.push(e.data)};
    offlineRecorder.onstop=async()=>{try{await transcribeRecording(new Blob(offlineChunks,{type:offlineRecorder.mimeType||'audio/webm'}))}catch(error){$('#voiceStatus').textContent=`Offline voice failed: ${error.message}`}finally{offlineStream.getTracks().forEach(track=>track.stop());mic.disabled=false;mic.classList.remove('listening');micLabel.textContent='Speak again'}};
    offlineRecorder.start();
    mic.classList.add('listening');micLabel.textContent='Stop & transcribe';$('#voiceStatus').textContent='Recording locally—click again when you finish speaking.';
  }catch(error){$('#voiceStatus').textContent='Microphone access is required for offline voice input. Allow it, then try again.'}
};
