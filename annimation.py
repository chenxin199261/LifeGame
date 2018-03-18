import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

dim =100
fileIn=open('output','r')
listIn=fileIn.readlines()



fig2 = plt.figure()
plt.axis('off')
plt.axis('off')
plt.grid(True)
fig2.tight_layout()
ims = []
for add in range(len(listIn)):
    mat=np.zeros((dim,dim))
    coor = listIn[add].split(";")
    for pair in range(len(coor)-1):
        temp = coor[pair].split()
        x = int(temp[0])-1
        y = int(temp[1])-1
        mat[x][y] = 1
    ims.append((plt.matshow(mat,fignum=0, cmap=plt.cm.gray_r),))


im_ani = animation.ArtistAnimation(fig2, ims, interval=100, repeat_delay=1000,
                                   blit=True)
# To save this second animation with some metadata, use the following command:
im_ani.save('im1.gif',writer='imagemagick')
# plt.matshow(np.around(np.random.rand(1024, 1024)), fignum=100, cmap=plt.cm.gray)
#plt.show()

