@testset "FrontPanelAPI Version Check" begin
  major = GetAPIVersionMajor()
  minor = GetAPIVersionMinor()
  micro = GetAPIVersionMicro()
  @test major == 5
  @test minor >= 2
end
