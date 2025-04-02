SetFilterMTMode ("QTGMC", 2)
AVISource(".avi")
AudioDub(WAVSource(".wav"))
#DelayAudio(-0.26) # Sync external audio capture
AssumeTFF()
#AssumeFrameBased() # Source is progressive, e.g. film transfer
#Telecide() # Fix field order for interlaced film transfer
Crop(8, 0, 704, 576)
#ConvertToYUV444().Crop(7, 0, 704, 576).ConvertToYUY2() # Precise crop
#Trim(0, 100000)
#a = Trim(0, 100000)
#b = Trim(0, 100000)
#AlignedSplice(a, b)
#deint = AssumeTFF().QTGMC(Preset="Slower", SourceMatch=3, Lossless=2).SelectEven()
#ApplyRange(0, 0, "Merge", deint, 1.0)
#ColorYUV(gain_u = 0.0, off_u = 0.0, gamma_u = 0.0, cont_u = 0.0) # Adjust chroma
#ColorYUV(gain_v = 0.0, off_v = 0.0, gamma_v = 0.0, cont_v = 0.0)
#Levels(0, 1.0, 255, 0, 255, dither=true, coring=false) # Adjust levels
#Tweak(hue = 0.0, sat = 1.0, bright = 0.0, cont = 1.0, coring=false, dither=true, dither_strength=0.66)
#VideoTek() # Check levels
Prefetch(16) __END__ # Topaz Video AI

raw = ConvertToYUV422()
raw.Separatefields()
src = Overlay(SelectEven().AddBorders(0, 288, 0, 0), SelectOdd(), opacity=1.0).AssumeFrameBased()
#src = raw # Uncomment for progressive source
#TemporalDegrain2(src, degrainTR=1, grainLevel=0, postFFT=0, postSigma=0) # Low
TemporalDegrain2(src, degrainTR=1, grainLevel=1, postFFT=0, postSigma=1) # Medium
#TemporalDegrain2(src, degrainTR=2, grainLevel=2, postFFT=1, postSigma=2).Sharpen(0.25, 0.0) # High
#PointResize(src, 704, 1152).ConvertToYV12().MCTD(settings="medium", chroma=true, truemotion=true).PointResize(704, 576).ConvertToYUV422() # Alternative
MergeLuma(src, 0.66) # Restore original detail
MergeChroma(src, 0.33)
#MergeChroma(CCD(ConvertToRGB32(), 100, ShowNoise=false).ConvertToYUV422(), 1.0) # Extreme chroma denoise
#RemoveDirtMC(20) # Minor dropout fix
Interleave(Crop(0, 0, 704, 288), Crop(0, 288, 704, 288)).AssumeFieldBased().Weave().AssumeTFF() # Comment out for progressive source
#Sharpen(0.25, 0.0) # Minor horizontal sharpen
#Overlay(raw, mode="difference") # Check denoise
ConvertToYUY2() # Leave as 4:2:2 for component video sources
#ConvertToYV12(interlaced=true) # Convert to 4:2:0 for rips or composite video sources
#ConvertToYV12(interlaced=false) # Convert to 4:2:0 for progressive rips
Prefetch(16) __END__ # x264 encoding

QTGMC(Preset="Slower", SourceMatch=3, Lossless=2)  # Twice refined source-match with fake lossless. Almost perfect fidelity mode with few artefacts
#QTGMC(Preset="Slower", SourceMatch=3, Lossless=1)  # Twice refined source-match with true lossless. Exact detail, but likely combing and shimmer
#QTGMC(Preset="Slow", SourceMatch=3, Lossless=2, MatchEnhance=0.75) # Further enhance detail found by refined match, a little sharper, may be noisier
#QTGMC(Preset="Slow", SourceMatch=3, Lossless=2, EZDenoise=2.00, ChromaNoise=true, ShowNoise=false, DenoiseMC=true) # Fast denoise, 4:2:0 input ONLY

#Crop(0, 0, 702, 576).ConvertToYV12() # Crop to exact dimensions
#ConvertToYUV444().Crop(1, 0, 702, 576).ConvertToYV12() # Precise crop
#LanczosResize(768, 576).Prefetch(16) __END__ # x264 encoding, deinterlaced, square pixels

LanczosResize(1408, 1152).ConvertToYV12()
Merge(LWLibavVideoSource("_prob4.avi"), 0.5) # Insert Topaz output here
Crop(2, 0, 1404, 1152)
#Stab(range=1, dxmax=10, dymax=10, mirror=15) # Stabilize film source
#RemoveDirtMC(30) # Clean film source
ColorMatrix(mode="Rec.601->Rec.709", clamp=0)
#SincResize(1440, 576).Spline64Resize(1440, 1080)
#SincResize(1920, 576).Spline64Resize(1920, 1440)
#LanczosResize(1440, 1080)
LanczosResize(1920, 1440)
#VideoTek() # Check levels
Prefetch(16) # Encoding for Youtube
