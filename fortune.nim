import strutils, os, sequtils, algorithm

# Change accordingly
# see chunkFortunes.nim
const folder = currentSourcePath.parentDir
const headerLocation = folder & "/header.txt"
const fortunePath = folder & "/fortunes/"
const fortuneSep = "\r\n%\r\n"
const header = slurp(headerLocation)
const fortuneIdxList = header.split(", ").map(parseInt)

func findFilename(fortuneNum: Natural): (int, string) = 
  # we want an index strictly <= to fortuneNum, which is upperBound - 1
  let i = fortuneIdxList.upperBound(fortuneNum) - 1
  let fileIdx = fortuneIdxList[i]
  let filename = fortunePath & "fortune-" & $fileIdx & ".txt"
  (fileIdx, filename)

proc main() =
  if os.paramCount() == 1:
    let fortuneNum = os.paramStr(1).parseInt()
    let (fileIdx, filename) = findFilename(fortuneNum)
    let fortunes = readFile(filename).split(fortuneSep)
    let fortuneIdx = fortuneNum - fileIdx
    let fortuneWanted = fortunes[fortuneIdx]
    echo "Your lucky number is ", fortuneNum
    echo fortuneWanted
  else:
    echo "Please enter a fortune number"
 
main()

