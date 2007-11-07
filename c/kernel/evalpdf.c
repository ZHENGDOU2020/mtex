/**
 * @file   evalpdf.c
 * @author ralf
 * @date   Thu Oct 12 07:31:18 2006
 * 
 * @brief  evaluates a pdf that is given by their Fourier coefficients
 * 
 * 
 */

#include <math.h>
#include <complex.h>
#include <pio.h>
#include <helper.h>
#include <nfft3.h>
#include <pdf.h>

#define Nparam 3

int main(int argc,char *argv[]){

  nfsft_plan plan;
  char f_out_name[BUFSIZ];
  complex *P_hat;
  double *r;
  double *P;
  int lr;
  int lP_hat;
  int bw;

  param_file_type param[Nparam] = 
    {{"r:"    ,"DATA_FILE" ,&r       ,&lr     ,2*sizeof(double)},
     {"P_hat:","DATA_FILE" ,&P_hat   ,&lP_hat ,sizeof(complex)},
     {"res1:","%s ",&f_out_name,NULL,0}};
    
  FILE *f_param;
  FILE *f_out;

  printf("\n ------ MTEX -- Fourier to PDF -------- \n");

  if (argc<2) {
    printf("Error! Missing parameter - parameter_file.\n");
    printf("%s\n",argv[0]);
    abort();
  }
  
  /* read parameter file */
  f_param = check_fopen(argv[1],"r");
  if (read_param_file(f_param,param,Nparam,argc==2)+1<Nparam){
    printf("Some parameters not found!");
    abort();
  }
  fclose(f_param);

  /*init nfsft plan */
  bw = sqrt(lP_hat)-1;
  printf("bandwidth: %d\n",bw);
  nfsft_precompute(bw,1000000,0U,0U);

  plan.x = r;
  nfsft_init_advanced(&plan,bw,lr,
		  NFSFT_MALLOC_F | NFSFT_MALLOC_F_HAT);
  set_f_hat(&plan,plan.f_hat,P_hat);

  /*vpr_complex(plan.f_hat,plan.N_total,"ndsft, vector f_hat");*/

  /* transform */
  nfsft_trafo(&plan);
  
  /* save results */
  /*vpr_complex(plan.f,plan.M_total,"ndsft, vector f");*/
  P = (double*) malloc(sizeof(double)*lr);
  v_memcpy_complex2double(P,plan.f,lr);
  f_out = check_fopen(f_out_name,"w");
  fwrite(P,sizeof(double),lr,f_out);
  fclose(f_out);

  /* free memory */
  free(r);
  free(P);
  free(P_hat);
  nfsft_finalize(&plan);
  
  return(0);
}
