function RemoveDirt(clip input, int limit, bool _grey)
{
  clensed=input.Clense(grey=_grey, cache=4)
  alt=input.RemoveGrain(2)
  return RestoreMotionBlocks(clensed,input,alternative=alt,pthreshold=6,cthreshold=8,gmthreshold=40,dist=3,dmode=2,debug=false,noise=limit,noisy=4, grey=_grey)
}
function RemoveDirtMC(clip,int limit, bool "_grey")
{
  _grey=default(_grey, false)
  limit = default(limit,6)
  i=MSuper(clip,pel=2)
  bvec = MAnalyse(i,isb=false, blksize=8, delta=1, truemotion=true)
  fvec = MAnalyse(i,isb=true, blksize=8, delta=1, truemotion=true)
  backw = MFlow(clip,i,bvec)
  forw  = MFlow(clip,i,fvec)
  clp=interleave(backw,clip,forw)
  clp=clp.RemoveDirt(limit,_grey)
  clp=clp.SelectEvery(3,1)
  return clp
}
