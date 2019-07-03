setHook("rstudio.sessionInit", function(newSession) {
    if (newSession) {
        Sys.setenv(RSTUDIO_PROXY=rstudioapi::translateLocalUrl('http://127.0.0.1:4321'))
    }
}, action = "append")
