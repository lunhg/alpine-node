let msg = "docker run redelivre:alpine-node -it"
[
    "--[PARAMS] execute a registered npm command with current parameters",
    "[ARGS]  -- execute a registered npm command with current arguments",
    "--[PARAMS] [ARGS] execute a registered node command with current parameters and arguments"
].forEach(function(k, v){
    console.log(`${msg} ${k}`);   
});
