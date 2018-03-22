program main
  implicit none
  integer,parameter :: N = 100 ! Canvas Dimension 
  integer :: stat(N,N),stat_new(N,N)
  real    :: randTemp(N,N)

  integer,parameter :: maxStep = 500 ! Maximun step
  integer :: step
  integer :: i,j,k,l
  integer :: i2,j2
  
  integer :: sur_live
  include 'omp_lib.h'
! 1. Generate Random life state
  call random_number(randTemp)
  stat = ceiling(randTemp*2)-1
  call outPut(N,stat)



! 2. Evole
  step = 1
  do while(step .le. maxStep)
     stat_new = 0
     !$OMP PARALLEL SHARED(stat,stat_new) PRIVATE(i,j,k,l,i2,j2,sur_live) 
     !$OMP DO
     do i = 1,N
        do j = 1,N
           ! couting surrounding live Cell
           sur_live = 0
           do k=-1,1
             do l=-1,1
                i2 = i+k
                j2 = j+l
                if (i2<1) i2=i2+N ! periodic condition
                if (j2<1) j2=j2+N 
                if (i2>N) i2=i2-N
                if (j2>N) j2=j2-N
                if (stat(i2,j2) == 1) sur_live = sur_live+1  
             enddo
           enddo
           sur_live = sur_live - stat(i,j)
           ! Change live state
           if (stat(i,j)==0) then 
              if(sur_live ==3 ) stat_new(i,j) = 1        
           else
              if(sur_live ==3 .or. sur_live==2 ) stat_new(i,j) = 1 
           endif
        enddo
     enddo
     !$OMP END DO
     !$OMP END PARALLEL
     stat = stat_new
     step = step +1
     call outPut(N,stat)
  enddo
end program main

subroutine outPut(N,stat)
  implicit none
  integer :: i,j
  integer :: N,stat(N,N)
  open(101,file='output',access='append')
 ! write(101,'(i5)',advance='no'),N
  do i = 1,N
     do j = 1,N
        if(stat(i,j) == 1 ) then
          write(101,'(i5,i5,";")',advance='no'),i,j
        endif
     enddo
  enddo
  close(101)
end subroutine outPut
