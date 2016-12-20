
def whiteElephantV2(numberOfElves):
  elvesWithGifts = range(numberOfElves)
  stillPlaying = len(elvesWithGifts)
  stealer = 0

  iterations = 0
  
  while (stillPlaying > 1):
    stealee = ((stillPlaying/2) + stealer) % stillPlaying

    #elvesWithGifts.remove(at: stealee)
    del elvesWithGifts[stealee]
    stillPlaying -= 1
    
    stealer = 0 if (stealer >= stillPlaying) else  ((stealer+1) % stillPlaying)

    if (iterations % 10000 == 0):
      print "%d iterations" % iterations

    iterations += 1
  
  return elvesWithGifts[0]

if __name__ == '__main__':
  numberOfElves = 3001330;
  result = whiteElephantV2( numberOfElves )
  
  print result
