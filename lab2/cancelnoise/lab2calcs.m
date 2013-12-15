%% MSI
y=y_msi;
u=u_msi;

iddata_sig=iddata(y,u,ts);
                             
% Import   iddata_sig                 
iddata_sigd = dtrend(iddata_sig,0);      
iddata_sigdd = dtrend(iddata_sigd,1);

iddata_sig_valid = iddata_sigdd([fs*4:fs*5]);
iddata_sig_estim = iddata_sigdd([fs*5:fs*6]);

th=arx(iddata_sig_estim,[0 10 47]);
[yh,fit,x0] = compare(iddata_sig_valid,th,5);
fit

[c l]=xcorr(y([fs*4:fs*5]),u([fs*4:fs*5]));
[C,I] = max(c);
nk_xcorr = l(I)

bhat=th.b;
shat=y-filter(bhat,1,u);
[c l]=xcorr(shat([fs*4:fs*5]),200);
figure(1)
stem(l,c);

seng = sum(abs(shat([fs*5:fs*6])).^2)/length(shat([fs*5:fs*6]));
yeng = sum(abs(y([fs*5:fs*6])).^2)/length(y([fs*5:fs*6]));

1-seng/yeng
figure(2)
stem(th.b);
hold on;
plot(2.*th.db,'r');
hold off;

%% CHP
y=y_chp;
u=u_chp;

iddata_sig=iddata(y,u,ts);
                             
% Import   iddata_sig                 
iddata_sigd = dtrend(iddata_sig,0);      
iddata_sigdd = dtrend(iddata_sigd,1);

iddata_sig_valid = iddata_sigdd([fs*4:fs*5]);
iddata_sig_estim = iddata_sigdd([fs*5:fs*6]);

th=arx(iddata_sig_estim,[0 20 47]);
[yh,fit,x0] = compare(iddata_sig_valid,th,5);
fit

[c l]=xcorr(y([fs*4:fs*5]),u([fs*4:fs*5]));
[C,I] = max(c);
nk_xcorr = l(I)

bhat=th.b;
shat=y-filter(bhat,1,u);
[c l]=xcorr(shat([fs*4:fs*5]),200);
figure(1)
stem(l,c);

seng = sum(abs(shat([fs*5:fs*6])).^2)/length(shat([fs*5:fs*6]));
yeng = sum(abs(y([fs*5:fs*6])).^2)/length(y([fs*5:fs*6]));

1-seng/yeng
figure(2)
stem(th.b);
hold on;
plot(2.*th.db,'r');
hold off;

%% SQW
y=y_sqw;
u=u_sqw;

iddata_sig=iddata(y,u,ts);
                             
% Import   iddata_sig                 
iddata_sigd = dtrend(iddata_sig,0);      
iddata_sigdd = dtrend(iddata_sigd,1);

iddata_sig_valid = iddata_sigdd([fs*4:fs*5]);
iddata_sig_estim = iddata_sigdd([fs*5:fs*6]);

th=arx(iddata_sig_estim,[0 15 47]);
[yh,fit,x0] = compare(iddata_sig_valid,th,5);
fit

[c l]=xcorr(y([fs*4:fs*5]),u([fs*4:fs*5]));
[C,I] = max(c);
nk_xcorr = l(I)

bhat=th.b;
shat=y-filter(bhat,1,u);
[c l]=xcorr(shat([fs*4:fs*5]),200);
figure(1)
stem(l,c);

seng = sum(abs(shat([fs*5:fs*6])).^2)/length(shat([fs*5:fs*6]));
yeng = sum(abs(y([fs*5:fs*6])).^2)/length(y([fs*5:fs*6]));

1-seng/yeng
figure(2)
stem(th.b);
hold on;
plot(2.*th.db,'r');
hold off;

%% WGN
y=y_wgn;
u=u_wgn;

iddata_sig=iddata(y,u,ts);
                             
% Import   iddata_sig                 
iddata_sigd = dtrend(iddata_sig,0);      
iddata_sigdd = dtrend(iddata_sigd,1);

iddata_sig_valid = iddata_sigdd([fs*4:fs*5]);
iddata_sig_estim = iddata_sigdd([fs*5:fs*6]);

th=arx(iddata_sig_estim,[0 5 46]);
[yh,fit,x0] = compare(iddata_sig_valid,th,5);
fit

[c l]=xcorr(y([fs*4:fs*5]),u([fs*4:fs*5]));
[C,I] = max(c);
nk_xcorr = l(I)

bhat=th.b;
shat=y-filter(bhat,1,u);
[c l]=xcorr(shat([fs*4:fs*5]),200);
figure(1)
stem(l,c);

seng = sum(abs(shat([fs*5:fs*6])).^2)/length(shat([fs*5:fs*6]));
yeng = sum(abs(y([fs*5:fs*6])).^2)/length(y([fs*5:fs*6]));

1-seng/yeng

figure(2)
stem(th.b);
hold on;
plot(2.*th.db,'r');
hold off;

