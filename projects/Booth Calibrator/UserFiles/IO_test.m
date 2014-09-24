% Script to analyze input/output data independently

[inspec,freqs2] = pyulear(input,order,256,Fs);
[outspec,freqs2] = pyulear(output,order,256,Fs);

%figure;loglog(freqs2(lowf:highf),inspec(lowf:highf));
figure;loglog(freqs2,outspec);