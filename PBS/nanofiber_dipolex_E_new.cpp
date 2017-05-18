//This program generates input and pbs files

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
int main(int argc, char **argv)
{
 double q0i,q1i;
 int i;

 // Scaling factor for the number of points in the parametrization
 int N=1;

 // Definition of the waveguide geometry with the radius of the nanofiber.
 double a=225;

 // Wavelength
 double lam=894;

 // Position at which the LDOS is calculated
 //double x0=270;
 //double x1=572.5;
 //int nx=14;
 double x=530;
 double y=0;

 // wavevector range
 double q0=0;
 double q1=1.45;
 int nq=146;
 int nint=1;

 // dielectric function definition
 double reps=2.1013;//1.4496^2;
 double ieps=0.001;

 // dipole momentum vector.
 double dx_r=1;
 double dx_i=0;
 double dy_r=0;
 double dy_i=0;
 double dz_r=0;
 double dz_i=0;

 char inname[100], pbsname[100], runname[100];

 sprintf(runname,"run_dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d_%d.bs"
                ,N,lam,reps,ieps,a,x,y,q0,q1,nq,nint);

 FILE *frun;
 frun=fopen(runname,"w");
 fprintf(frun,"#/bpbs/bash\n");
 fclose(frun);

 for(i=0;i<nint;i++){
   if(i==0) q0i=q0; else q0i=q0+i*(q1-q0)/nint;
   q1i=q0i+(q1-q0)/nint;

   sprintf(inname,"dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d.in"
                 ,N,lam,reps,ieps,a,x,y,q0i,q1i,nq);

   // Input file
   FILE *fin;
   fin=fopen(inname,"w");

   fprintf(fin,"\n");
   fprintf(fin,"\n");
   fprintf(fin,"epsilon 2 constant %g %g\n",reps,ieps);
   fprintf(fin,"\n");
   fprintf(fin,"clear-geometry\n");
   fprintf(fin,"add-arc 2 1 0 0 %g %g 0 0 360 %g\n",a,a,N*floor(6.283/3.0*a));
   fprintf(fin,"\n");
   fprintf(fin,"write-geometry geom_a_%g.dat\n",a);
   fprintf(fin,"write-regions 101 geom_regions_a_%g.dat\n",a);
   fprintf(fin,"\n");
   fprintf(fin,"photon-wavelength %g %g 1\n",lam,lam);
   fprintf(fin,"\n");
   fprintf(fin,"q %g %g %d\n",q0i,q1i,nq);
   fprintf(fin,"\n");
   fprintf(fin,"dipole %g %g %g %g %g %g %g %g",x,y,dx_r,dx_i,dy_r,dy_i,dz_r,dz_i);
   fprintf(fin,"\n");
   fprintf(fin,"grid %g %g 1 %g %g 1\n",x,x,y,y);
   fprintf(fin,"induced-field\n");
   fprintf(fin,"\n");
   fprintf(fin,"begin-calculation\n");
   fprintf(fin,"\n");
   fprintf(fin," calc full-near-field dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d.dat\n",N,lam,reps,ieps,a,x,y,q0i,q1i,nq);
   fprintf(fin,"end-calculation\n");
   fprintf(fin,"end\n");
   fprintf(fin,"\n");
   fclose(fin);

   // PBS file
   sprintf(pbsname,"dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d.pbs",N,lam,reps,ieps,a,x,y,q0i,q1i,nq);
   FILE *fpbs;
   fpbs=fopen(pbsname,"w");

   fprintf(fpbs,"#PBS -N dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d\n",N,lam,reps,ieps,a,x,y,q0i,q1i,nq);
   fprintf(fpbs,"#PBS -l nodes=1:ppn=2\n");
   fprintf(fpbs,"#PBS -l pmem=1000m\n");
   fprintf(fpbs,"#PBS -l walltime=30:00:00\n");
   fprintf(fpbs,"#PBS -V\n");
   fprintf(fpbs,"echo ""My job ran on:""\n");
   fprintf(fpbs," cat $PBS_NODEFILE\n");
   fprintf(fpbs," cd $PBS_O_WORKDIR\n");
   fprintf(fpbs,"/users/qxd/bem2D/./bem2D dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d.in\n",N,lam,reps,ieps,a,x,y,q0i,q1i,nq);
   fclose(fpbs);

   // BS file
   frun=fopen(runname,"a");
   fprintf(frun,"qsub dipolex_E_N_%d_lam_%g_eps_%g_%g_a_%g_x_%g_y_%g_q_%g_%g_%d.pbs\n",N,lam,reps,ieps,a,x,y,q0i,q1i,nq);
   fclose(frun);

 }



 return 0;
}
