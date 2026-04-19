window.api.onGPUData((gpus) => {
	console.log("GPU DATA:", gpus);
  
	const list = document.getElementById("gpu-list");
	list.innerHTML = "";
  
	gpus.forEach(gpu => {
	  const div = document.createElement("div");
	  div.textContent = gpu;
	  list.appendChild(div);
	});
  });