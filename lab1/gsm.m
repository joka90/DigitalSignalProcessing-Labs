%%
load('ms');

F_cuttoff=2000
[b,a]=butter(5,F_cuttoff*2/fs);

a_02_lp = filtfilt(b,a,y(2,:)');

no_of_segs = floor(length(a_02_lp)/160);

sound = a_02_lp(1:no_of_segs*160);%y(2,1:no_of_segs*160);

% Matris med segmenten
segmat = reshape(sound,160,no_of_segs);

%%

decoded = zeros(size(sound));

for k=1:200;
    [apoly, A, D] = encode(segmat(:,k));
    impulse = [sqrt(A) zeros(1,D-1)];
    n = ceil(160/length(impulse));
    train=[];
    for i=1:n
        train = [train impulse];
    end
    decoded(160*(k-1)+1:160*k) = filter(1,apoly,train(1:160));
end

%%
soundsc(decoded,8000);