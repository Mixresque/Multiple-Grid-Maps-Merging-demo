import random
from shutil import copyfile

n = 7;
src = 'data/In';
dst = 'datax/In';
suffix = '.png';
a = list(range(1,n+1));
random.shuffle(a);

for i in range(n):
    copyfile(src+str(a[i])+suffix, dst+str(i+1)+suffix);

print(a);
