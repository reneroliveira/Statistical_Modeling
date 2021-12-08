#Experiments

set.seed(1)
T <- 1000
X1 <- rep(0,T)
X2 <- rep(0,T)
X3 <- rep(0,T)

N1 <- runif(T,-0.5,0.5)#rnorm(T)
N2 <- runif(T,-0.5,0.5)#rnorm(T)
N3 <- runif(T,-0.5,0.5)#rnorm(T)

for(t in 3:n)
{
  X1[t] <- 0.3*X1[t-1]+N1[t]
  X2[t] <- 0.5*X1[t]+0.8*X2[t-1]+0.4*X1[t-1]+N2[t]
  X3[t] <- 0.5*X2[t]-0.6*X3[t-1]+0.7*x1[t-2]+N3[t]
}

# granger_dag_partial<-function(M,alpha,max_lag,output = TRUE)
# {
#   #M (nxp) should consists of p cols, each of which is the realization of one
#   #variable, that has n data points.
#   #(i,j)==1 in the answer matrix means causal link i->j
#   #(i,j)==0 in the answer matrix means no causal link i->j
#   np<-dim(M)
#   CC<-matrix(88,np[2],np[2])
#   for(i in 1:(np[2]))
#   {
#     for(j in (1:np[2]))
#     {
#       if(i==j){
#         CC[i,j]<-0
#       }else{
#       Fc<-granger_partial(M[,j],M[,i],M[,-c(i,j)],alpha,max_lag, output)
#       ifelse(Fc[1]<Fc[2],
#              CC[i,j]<-0,
#              CC[i,j]<-1)
#       Fc<-granger_partial(M[,i],M[,j],M[,-c(i,j)],alpha,max_lag, output)
#       ifelse(Fc[1]<Fc[2],
#              CC[j,i]<-0,
#              CC[j,i]<-1)
#       }
#       }
#   }
#   return(CC)
# }

granger_dag <- granger_dag_partial(cbind(X1,X2,X3),alpha = 0.05,max_lag = 2,output = FALSE)

X_can <- tsdata2canonicalform(cbind(X1,X2,X3),2)
lingam_model <- VARLiNGAM(X_can,"ols", pruning=FALSE,ntests=FALSE)
timino_dag <- timino_dag(cbind(X1,X2,X3), alpha = 0.05, max_lag = 2, model = traints_linear, indtest = indtestts_hsic, output = TRUE)

A0 <- lingam_model$Bhat[[1]]
A1 <- lingam_model$Bhat[[2]]
A2 <- lingam_model$Bhat[[3]]

causal_order <- lingam_model$var_order
# 
# granger_dag2 <- granger_dag_pairwise(cbind(X3,X2),alpha = 0.05,max_lag = 2)
# X_can2 <- tsdata2canonicalform(cbind(X2,X3),2)
# lingam_model2 <- VARLiNGAM(X_can2,"ols", pruning=FALSE,ntests=FALSE)
# timino_dag2 <- timino_dag(cbind(X2,X3), alpha = 0.05, max_lag = 2, model = traints_linear, indtest = indtestts_hsic, output = TRUE)
