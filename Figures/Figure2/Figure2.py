def BestMatch(sample, path):
  dataIn=open(f"{path}/{sample}.txt").readlines()[1:]
  dataOut=open(f"{path}/{sample}_highestScore.txt", 'w')
  bestMatch={}
  for i in dataIn:
    curr=i.split('\t')
    name=curr[0]
    if name not in bestMatch.keys():
      bestMatch[name]=[float(curr[5]), float(curr[5]), 1]
    else:
      bestMatch[name][1]=float(curr[5]) + bestMatch[name][1]
      if float(curr[5]) > bestMatch[name]:
        bestMatch[name][0]=float(curr[5])
      bestMatch[name][2]=bestMatch[name][2]+1
  
  coords=sorted(bestMatch.keys())
  
  for i in coords:
    dataOut.write(i + '\t' + str(bestMatch[i][0]) + '\t' +  
    str(bestMatch[i][1]) + '\t' + str(bestMatch[i][2]) + '\n')
  dataOut.close()
  
samples=['overlapping_GORS_GCR_scores', 'overlapping_GORS_GCR_scores_A549', \
'overlapping_GORS_GCR_scores_U2OS']

path = '../../figure_outputs'

for j in samples:
  BestMatch(j, path)