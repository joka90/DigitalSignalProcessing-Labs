load a_02
Ts=1/8000;
fs=8000;

%% pre processing
a_02_iddata = iddata(y(2,:)',[],Ts);
a_02_iddata_detrend=detrend(a_02_iddata,0);

%lp-filter
F_cuttoff=1200
[b,a]=butter(5,F_cuttoff*2/fs);

a_02_lp = filtfilt(b,a,a_02_iddata_detrend.y);
a_02_lp_iddata = iddata(a_02_lp,[],Ts)

a_02_iddata_valid = a_02_lp_iddata([16484:31766]);
a_02_iddata_estim = a_02_lp_iddata([3640:16360]);

figure(30)
plot(a_02_lp_iddata,'b',a_02_iddata_estim,'y',a_02_iddata_valid,'r')

title('Vowel för a')
xlabel('Tid[s]')
legend('Orginal','Valideringsdata','Estimeringsdata')
pdf_print('vowel_trim_a.pdf')

%plotta frekvensspektra för de olika delarna
figure(31)
plot(chgFreqUnit(fft(a_02_iddata_detrend),'Hz'),'b',chgFreqUnit(fft(a_02_iddata_estim),'Hz'),'y',chgFreqUnit(fft(a_02_iddata_valid),'Hz'),'r')
title('Vowel frekvensspektra för a')
legend('Orginal','Valideringsdata','Estimeringsdata')
axis([0 2000 0 3.5])
xlabel('Frekvens[Hz]')
pdf_print('vowel_fft_a.pdf')



%% AR-modeller
ar30=ar(a_02_iddata_estim,30);
ar20=ar(a_02_iddata_estim,20);
ar16=ar(a_02_iddata_estim,16);
ar14=ar(a_02_iddata_estim,14);
ar12=ar(a_02_iddata_estim,12);
ar10=ar(a_02_iddata_estim,10);
ar8=ar(a_02_iddata_estim,8);
ar6=ar(a_02_iddata_estim,6);

Ne=length(a_02_iddata_estim.y);
est_diag=[...
sum(pe(ar6,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar8,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar10,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar12,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar14,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar16,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar20,a_02_iddata_estim.y).^2)/Ne
sum(pe(ar30,a_02_iddata_estim.y).^2)/Ne];

valid_diag=[...
sum(pe(ar6,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar8,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar10,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar12,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar14,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar16,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar20,a_02_iddata_valid.y).^2)/Ne
sum(pe(ar30,a_02_iddata_valid.y).^2)/Ne];

prederr(ar30,a_02_iddata_valid.y)
[err,x0e,sys_pred] = pe(a_02_iddata_valid,ar30)

model_order=[6 8 10 12 14 16 20 30];
figure(40)
plot(model_order,est_diag','-',model_order,valid_diag','--')

%%
figure(32)
pzmap(ar16)
title('Pool/nollställediagram för a')
pdf_print('vowel_pzmap_a_ar16.pdf')

opt = compareOptions;
figure(33)
[y,fit,x0] =compare(a_02_iddata_valid,ar30,ar20,ar16,ar14,ar12,ar10,ar8,ar6,5,opt);

[model_order(end:-1:1)']
fit

%pdf_print('vowel_compare_a.pdf')

%resid(a_02_iddata_valid,ar20,'Corr')


%% spela modell
%Use the signal period as pulse interval.
%% generera pulståg
f=101.2%o grundton = 101.2 hz
f=110.7%a grundton = 110.7 hz
sampleperiod=1/(f*Ts)
u=[1 zeros(1,floor(sampleperiod)-1)];
for i=0:7;
   u=[u u];
end

%plot(abs(fft(u)))

%% spela upp
yhat = filter(1,ar16.a,u);

yhat_skal=sum(yhat.^2)/length(yhat);
estim_skal=sum(a_02_iddata_estim.y.^2)/length(a_02_iddata_estim.y);

skalfaktor=sqrt(yhat_skal/estim_skal)
soundsc(yhat,fs)
%%
yhat_iddata = iddata(2.8e-5.*yhat',[],Ts);
figure(34)
plot(chgFreqUnit(fft(a_02_iddata_estim),'Hz'),'b',chgFreqUnit(fft(yhat_iddata),'Hz'),'r')
title('Vowel frekvensspektra för a, modell vs. verklighet')
legend('Verklighet','Modell')
axis([0 1600 0 3.5])
pdf_print('vowel_model_a.pdf')