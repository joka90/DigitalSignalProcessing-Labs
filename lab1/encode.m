function [apoly A D] = encode(seg_k)

iddata_k = iddata(seg_k,[],1/8000);

iddata_k = detrend(iddata_k);

k_ar = ar(iddata_k,8);

% Polerna
k_poles = roots(k_ar.a);

% Stabilisera
k_stab_poles = k_poles;

for i=1:length(k_poles)
    if abs(k_poles(i)) > 1
        k_stab_poles(i) = 1/conj(k_poles(i));
    end
end

apoly = poly(k_stab_poles);

% Sätt ihop till ny AR
k_stab_ar = k_ar;
set(k_stab_ar,'a',poly(k_stab_poles));

% Beräkna kovarians

e=filter(k_stab_ar.a,1,seg_k);
r=covf(e,100);

% Hitta amplitud och lag till största värde
[A,D] = max(r(20:end));
D = D + 19;