function [ out_MMAV2 ] = ModifiedMeanAbsValue2(input_waveform)
  N = length(input_waveform);
  weight = ones(N);
  for n = 1:1:N
    if n > 0.75*N
      weight(n) = 4*(n-N)/N;
    elseif n < 0.25*N
      weight(n) = 4*n/N;
    end
  end
  out_MMAV2 = (1/N)*sum(weight.*abs(input_waveform))
  end
