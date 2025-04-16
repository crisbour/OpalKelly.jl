using Test
using OpalKelly

@testset "FrontPanelAPI Version Check" begin
  major = get_api_version_major()
  minor = get_api_version_minor()
  micro = get_api_version_micro()
  @test major == 5
  @test minor >= 2
end
