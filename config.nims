let fortuneFile = "fortune.txt"
let headerFile = "header.txt"

task rebuildDB, "Rebuilds the fortune database":
  if not fileExists(fortuneFile):
    raise newException(OSError, "fortune.txt not found")
  selfExec "c -r chunkFortunes.nim"

task buildFortune, "Builds the fortune executable":
  if not fileExists(headerFile):
    rebuildDBTask()
  selfExec "c -d:release --gc:arc --exceptions:goto fortune.nim"
  exec "strip fortune.exe"
  

