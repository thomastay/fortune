import strutils, os

# Will break up fortune.txt into various page-sized files
# Writes the start of each index into header.txt

# Module level constants, change accordingly
const fortuneLocation = "fortune.txt"
const fortunePath = "fortunes/"
const numBytesInChar = 1 # 1 char is 1 byte
const pageSize = 4096 # approximate size of OS page
const headerLocation = "header.txt"

func chunkFortunes(fortunes: seq[string]): seq[Natural] =
  ## Chunk the file into (roughly) pageSized components 
  ## Might exceed slightly, so about 5-6KB roughly.
  var start: Natural = 0
  var count = 0
  for i, f in fortunes:
    count += len(f) * numBytesInChar
    if count >= pageSize or i == (len(fortunes) - 1):
      result.add(start)
      start = i + 1
      count = 0

proc writeFortunes() =
  discard existsOrCreateDir(fortunePath)
  ## Split fortunes into multiple, roughly page-sized files
  let fortunes = readFile(fortuneLocation).split("\r\n%\r\n")
  let fortuneIndices = fortunes.chunkFortunes()
  let n = len(fortuneIndices)
  for i in 1..n:
    let startIndex = fortuneIndices[i-1]
    let endIndex = if i == n: len(fortunes) - 1 else: fortuneIndices[i] - 1
    assert endIndex > startIndex
    let fortunesToWrite = fortunes[startIndex..endIndex]
    let filename = fortunePath & "fortune-" & $startIndex & ".txt"
    filename.writeFile(fortunesToWrite.join("\r\n%\r\n"))

# Write the count of files written
proc writeHeader() =
  let fortuneIndices = readFile(fortuneLocation)
      .split("\r\n%\r\n")
      .chunkFortunes()
  let headerFile = open(headerLocation, fmWrite)
  defer: headerFile.close()
  headerFile.write(fortuneIndices.join(", "))
  
writeHeader()
writeFortunes()


  

