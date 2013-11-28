%%
r1=covf(a_02_lp_iddata.y,100);
e=filter(ar6.a,1,a_02_lp_iddata.y);
r=covf(e,100);
x1=1:length(r1);
plot(x1,r.*1e5,'b',x1,r1,'r')

%%
t=0:0.001:4;
tao=-0.4
y1=0.1*sin(50*pi.*t)+sin(2*pi.*t);
y2=0.1*sin(50*pi.*t+pi*tao)+sin(2*pi.*t+pi*tao);
figure(1)
plot(t,y1,'b',t,y2,'r')
legend('\tau=0','\tau=-0.4')
pdf_print('gsm_covf.pdf')
r=covf(y1',length(t));
figure(2)
plot(r)

ar4=ar(y1,4);

e=filter(ar4.a,1,y1);
figure(3)
plot(t,e)
r=covf(e',100);
figure(4)
plot(r)