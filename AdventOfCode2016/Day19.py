
def whiteElephantV2(numberOfElves):
  elvesWithGifts = range(1,numberOfElves+1)
  stillPlaying = len(elvesWithGifts)
  stealer = 0

  iterations = 0
  
  while (stillPlaying > 1):
    stealee = ((stillPlaying/2) + stealer) % stillPlaying

    if (stillPlaying > 1 and stillPlaying < 20):
      print elvesWithGifts, elvesWithGifts[stealer], elvesWithGifts[stealee]

    #elvesWithGifts.remove(at: stealee)
    del elvesWithGifts[stealee]
    stillPlaying -= 1
    
    #stealer = 0 if (stealer >= stillPlaying) else  ((stealer+1) % stillPlaying)
    #stealer = 0 if (stealer >= stillPlaying) else  ((stealer+1) % stillPlaying)
    if (stealer >= stillPlaying):
      stealer = 0
    elif (stealee > stealer):
      stealer = ((stealer+1) % stillPlaying)
    #else 
    #  no change to stealer

    iterations += 1
    if (iterations % 10000 == 0):
      print "%d iterations, %d stillPlaying, %d len" % (iterations, stillPlaying, len(elvesWithGifts))

  #print elvesWithGifts, elvesWithGifts[stealer], elvesWithGifts[stealee]

  return elvesWithGifts[0]

if __name__ == '__main__':
  numberOfElves = 3001330
  #numberOfElves = 100

  result = whiteElephantV2( numberOfElves )
  
  print result

