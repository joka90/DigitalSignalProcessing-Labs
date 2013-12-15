sampletime=1/11025;
ts=sampletime;
fs=1/sampletime;

%% a

y=y(:);
u=u(:);

a_wgn=iddata(y,u,ts)
                             
% Import   a_wgn                 
a_wgnd = dtrend(a_wgn,0);      
a_wgndd = dtrend(a_wgnd,1);
figure(1)
plot(a_wgndd)
a_wgn_valid = a_wgndd([fs*4:fs*5]);
a_wgn_estim = a_wgndd([fs*5:fs*6]);

[c l]=xcorr(y,u);
figure(2)
stem(l,c);
[c l]=xcorr(y,u);
[C,I] = max(c);
nk_xcorr = l(I)



%%
i=40;
MAX=60;
th_wgn=arx([y u],[0 200 1]);

figure(3)
stem(th_wgn.b);
hold on;
plot(2.*th_wgn.db,'r');
hold off;

%% energy
bhat=th_wgn.b;
shat=y-filter(bhat,1,u);
energy_ratio=sum(abs(y(fs*4:fs*5))./abs(shat(fs*4:fs*5)))./length(shat(fs*4:fs*5))

%% compare
th_wgn=arx(a_wgn_estim,[0 40 47]);
figure(4)
[yh,fit,x0] =compare(a_wgn_valid,th_wgn,5);
fit