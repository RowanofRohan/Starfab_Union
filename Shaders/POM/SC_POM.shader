// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Decals POM"
{
	Properties
	{
		_Diffuse( "Diffuse", 2D ) = "white" {}
		[Normal] _ddna( "ddna", 2D ) = "white" {}
		_DDNAGlossmap( "DDNA Glossmap", 2D ) = "white" {}
		_Specular( "Specular", 2D ) = "white" {}
		_Disp( "Disp", 2D ) = "white" {}
		_Scale( "Scale", Float ) = 1
		_Bias( "Bias", Float ) = 0.5
		_Layers( "Layers", Range( 1, 200 ) ) = 40
		[Toggle( _INVERTBIAS_ON )] _InvertBias( "Invert Bias", Float ) = 0
		_NonPlanar( "Non-Planar", Int ) = 1
		_AlphaMidLevelControl( "Alpha Mid-Level Control", Float ) = -1
		[Toggle( _INVERTROUGHNESS_ON )] _InvertRoughness( "Invert Roughness", Float ) = 0
		_Brightness( "Brightness", Range( -1, 0 ) ) = -0.75
		_BaseColor( "Base Color", Color ) = ( 1, 1, 1, 1 )
		_Emission( "Emission", Color ) = ( 1, 1, 1, 1 )
		_SpecularColor( "Specular Color", Color ) = ( 1, 1, 1, 1 )
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardBRDF.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma dynamic_branch _INVERTBIAS_ON
		#pragma dynamic_branch _INVERTROUGHNESS_ON
		#define ASE_VERSION 19904
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float4 _BaseColor;
		uniform float4 _Emission;
		uniform float4 _SpecularColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ddna);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Disp);
		uniform float4 _Disp_ST;
		uniform int _NonPlanar;
		uniform float _Scale;
		uniform float _Layers;
		SamplerState sampler_Disp;
		uniform float _Bias;
		SamplerState sampler_ddna;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Specular);
		SamplerState sampler_Specular;
		uniform float _Brightness;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Diffuse);
		SamplerState sampler_Diffuse;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DDNAGlossmap);
		SamplerState sampler_DDNAGlossmap;
		uniform float _AlphaMidLevelControl;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Disp = i.uv_texcoord * _Disp_ST.xy + _Disp_ST.zw;
			float2 temp_output_6_0_g836 = uv_Disp;
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
			float3 lerpResult3_g749 = lerp( ase_viewDirSafeWS , Unity_SafeNormalize( i.viewDir ) , (float)saturate( _NonPlanar ));
			float3 break6_g749 = lerpResult3_g749;
			float2 appendResult101_g749 = (float2(break6_g749.x , break6_g749.y));
			float temp_output_9_0_g749 = _Layers;
			float2 temp_output_39_0_g836 = ( ( ( appendResult101_g749 / break6_g749.z ) * ( _Scale / temp_output_9_0_g749 ) ) / temp_output_9_0_g749 );
			float temp_output_10_0_g836 = 1.0;
			float dynamicSwitch14 = ( float )0;
			UNITY_BRANCH if ( _INVERTBIAS_ON )
			{
				dynamicSwitch14 = ( 1.0 - _Bias );
			}
			else
			{
				dynamicSwitch14 = _Bias;
			}
			float temp_output_5_0_g836 = dynamicSwitch14;
			float temp_output_8_0_g836 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g836 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g836 - 0.0 ) );
			float temp_output_11_0_g836 = 0.0;
			float lerpResult18_g836 = lerp( ( temp_output_8_0_g836 > temp_output_11_0_g836 ? 1.0 : 0.0 ) , ( temp_output_8_0_g836 < temp_output_11_0_g836 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g836 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g836 = lerp( temp_output_10_0_g836 , ( -0.5 * temp_output_10_0_g836 ) , lerpResult18_g836);
			float2 temp_output_6_0_g834 = ( temp_output_6_0_g836 - ( temp_output_39_0_g836 * lerpResult35_g836 ) );
			float2 temp_output_39_0_g834 = temp_output_39_0_g836;
			float temp_output_10_0_g834 = lerpResult35_g836;
			float temp_output_5_0_g834 = temp_output_5_0_g836;
			float temp_output_8_0_g834 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g834 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g834 - 0.0 ) );
			float temp_output_42_0_g836 = temp_output_9_0_g749;
			float temp_output_11_0_g834 = ( ( lerpResult35_g836 * ( 1.0 / temp_output_42_0_g836 ) ) + temp_output_11_0_g836 );
			float lerpResult18_g834 = lerp( ( temp_output_8_0_g834 > temp_output_11_0_g834 ? 1.0 : 0.0 ) , ( temp_output_8_0_g834 < temp_output_11_0_g834 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g834 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g834 = lerp( temp_output_10_0_g834 , ( -0.5 * temp_output_10_0_g834 ) , lerpResult18_g834);
			float2 temp_output_6_0_g827 = ( temp_output_6_0_g834 - ( temp_output_39_0_g834 * lerpResult35_g834 ) );
			float2 temp_output_39_0_g827 = temp_output_39_0_g834;
			float temp_output_10_0_g827 = lerpResult35_g834;
			float temp_output_5_0_g827 = temp_output_5_0_g834;
			float temp_output_8_0_g827 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g827 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g827 - 0.0 ) );
			float temp_output_42_0_g834 = temp_output_42_0_g836;
			float temp_output_11_0_g827 = ( ( lerpResult35_g834 * ( 1.0 / temp_output_42_0_g834 ) ) + temp_output_11_0_g834 );
			float lerpResult18_g827 = lerp( ( temp_output_8_0_g827 > temp_output_11_0_g827 ? 1.0 : 0.0 ) , ( temp_output_8_0_g827 < temp_output_11_0_g827 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g827 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g827 = lerp( temp_output_10_0_g827 , ( -0.5 * temp_output_10_0_g827 ) , lerpResult18_g827);
			float2 temp_output_6_0_g828 = ( temp_output_6_0_g827 - ( temp_output_39_0_g827 * lerpResult35_g827 ) );
			float2 temp_output_39_0_g828 = temp_output_39_0_g827;
			float temp_output_10_0_g828 = lerpResult35_g827;
			float temp_output_5_0_g828 = temp_output_5_0_g827;
			float temp_output_8_0_g828 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g828 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g828 - 0.0 ) );
			float temp_output_42_0_g827 = temp_output_42_0_g834;
			float temp_output_11_0_g828 = ( ( lerpResult35_g827 * ( 1.0 / temp_output_42_0_g827 ) ) + temp_output_11_0_g827 );
			float lerpResult18_g828 = lerp( ( temp_output_8_0_g828 > temp_output_11_0_g828 ? 1.0 : 0.0 ) , ( temp_output_8_0_g828 < temp_output_11_0_g828 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g828 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g828 = lerp( temp_output_10_0_g828 , ( -0.5 * temp_output_10_0_g828 ) , lerpResult18_g828);
			float2 temp_output_6_0_g829 = ( temp_output_6_0_g828 - ( temp_output_39_0_g828 * lerpResult35_g828 ) );
			float2 temp_output_39_0_g829 = temp_output_39_0_g828;
			float temp_output_10_0_g829 = lerpResult35_g828;
			float temp_output_5_0_g829 = temp_output_5_0_g828;
			float temp_output_8_0_g829 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g829 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g829 - 0.0 ) );
			float temp_output_42_0_g828 = temp_output_42_0_g827;
			float temp_output_11_0_g829 = ( ( lerpResult35_g828 * ( 1.0 / temp_output_42_0_g828 ) ) + temp_output_11_0_g828 );
			float lerpResult18_g829 = lerp( ( temp_output_8_0_g829 > temp_output_11_0_g829 ? 1.0 : 0.0 ) , ( temp_output_8_0_g829 < temp_output_11_0_g829 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g829 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g829 = lerp( temp_output_10_0_g829 , ( -0.5 * temp_output_10_0_g829 ) , lerpResult18_g829);
			float2 temp_output_6_0_g830 = ( temp_output_6_0_g829 - ( temp_output_39_0_g829 * lerpResult35_g829 ) );
			float2 temp_output_39_0_g830 = temp_output_39_0_g829;
			float temp_output_10_0_g830 = lerpResult35_g829;
			float temp_output_5_0_g830 = temp_output_5_0_g829;
			float temp_output_8_0_g830 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g830 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g830 - 0.0 ) );
			float temp_output_42_0_g829 = temp_output_42_0_g828;
			float temp_output_11_0_g830 = ( ( lerpResult35_g829 * ( 1.0 / temp_output_42_0_g829 ) ) + temp_output_11_0_g829 );
			float lerpResult18_g830 = lerp( ( temp_output_8_0_g830 > temp_output_11_0_g830 ? 1.0 : 0.0 ) , ( temp_output_8_0_g830 < temp_output_11_0_g830 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g830 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g830 = lerp( temp_output_10_0_g830 , ( -0.5 * temp_output_10_0_g830 ) , lerpResult18_g830);
			float2 temp_output_6_0_g832 = ( temp_output_6_0_g830 - ( temp_output_39_0_g830 * lerpResult35_g830 ) );
			float2 temp_output_39_0_g832 = temp_output_39_0_g830;
			float temp_output_10_0_g832 = lerpResult35_g830;
			float temp_output_5_0_g832 = temp_output_5_0_g830;
			float temp_output_8_0_g832 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g832 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g832 - 0.0 ) );
			float temp_output_42_0_g830 = temp_output_42_0_g829;
			float temp_output_11_0_g832 = ( ( lerpResult35_g830 * ( 1.0 / temp_output_42_0_g830 ) ) + temp_output_11_0_g830 );
			float lerpResult18_g832 = lerp( ( temp_output_8_0_g832 > temp_output_11_0_g832 ? 1.0 : 0.0 ) , ( temp_output_8_0_g832 < temp_output_11_0_g832 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g832 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g832 = lerp( temp_output_10_0_g832 , ( -0.5 * temp_output_10_0_g832 ) , lerpResult18_g832);
			float2 temp_output_6_0_g835 = ( temp_output_6_0_g832 - ( temp_output_39_0_g832 * lerpResult35_g832 ) );
			float2 temp_output_39_0_g835 = temp_output_39_0_g832;
			float temp_output_10_0_g835 = lerpResult35_g832;
			float temp_output_5_0_g835 = temp_output_5_0_g832;
			float temp_output_8_0_g835 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g835 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g835 - 0.0 ) );
			float temp_output_42_0_g832 = temp_output_42_0_g830;
			float temp_output_11_0_g835 = ( ( lerpResult35_g832 * ( 1.0 / temp_output_42_0_g832 ) ) + temp_output_11_0_g832 );
			float lerpResult18_g835 = lerp( ( temp_output_8_0_g835 > temp_output_11_0_g835 ? 1.0 : 0.0 ) , ( temp_output_8_0_g835 < temp_output_11_0_g835 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g835 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g835 = lerp( temp_output_10_0_g835 , ( -0.5 * temp_output_10_0_g835 ) , lerpResult18_g835);
			float2 temp_output_6_0_g831 = ( temp_output_6_0_g835 - ( temp_output_39_0_g835 * lerpResult35_g835 ) );
			float2 temp_output_39_0_g831 = temp_output_39_0_g835;
			float temp_output_10_0_g831 = lerpResult35_g835;
			float temp_output_5_0_g831 = temp_output_5_0_g835;
			float temp_output_8_0_g831 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g831 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g831 - 0.0 ) );
			float temp_output_42_0_g835 = temp_output_42_0_g832;
			float temp_output_11_0_g831 = ( ( lerpResult35_g835 * ( 1.0 / temp_output_42_0_g835 ) ) + temp_output_11_0_g835 );
			float lerpResult18_g831 = lerp( ( temp_output_8_0_g831 > temp_output_11_0_g831 ? 1.0 : 0.0 ) , ( temp_output_8_0_g831 < temp_output_11_0_g831 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g831 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g831 = lerp( temp_output_10_0_g831 , ( -0.5 * temp_output_10_0_g831 ) , lerpResult18_g831);
			float2 temp_output_6_0_g833 = ( temp_output_6_0_g831 - ( temp_output_39_0_g831 * lerpResult35_g831 ) );
			float2 temp_output_39_0_g833 = temp_output_39_0_g831;
			float temp_output_10_0_g833 = lerpResult35_g831;
			float temp_output_5_0_g833 = temp_output_5_0_g831;
			float temp_output_8_0_g833 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g833 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g833 - 0.0 ) );
			float temp_output_42_0_g831 = temp_output_42_0_g835;
			float temp_output_11_0_g833 = ( ( lerpResult35_g831 * ( 1.0 / temp_output_42_0_g831 ) ) + temp_output_11_0_g831 );
			float lerpResult18_g833 = lerp( ( temp_output_8_0_g833 > temp_output_11_0_g833 ? 1.0 : 0.0 ) , ( temp_output_8_0_g833 < temp_output_11_0_g833 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g833 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g833 = lerp( temp_output_10_0_g833 , ( -0.5 * temp_output_10_0_g833 ) , lerpResult18_g833);
			float2 temp_output_6_0_g814 = ( temp_output_6_0_g833 - ( temp_output_39_0_g833 * lerpResult35_g833 ) );
			float2 temp_output_39_0_g814 = temp_output_39_0_g833;
			float temp_output_10_0_g814 = lerpResult35_g833;
			float temp_output_5_0_g814 = temp_output_5_0_g833;
			float temp_output_8_0_g814 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g814 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g814 - 0.0 ) );
			float temp_output_42_0_g833 = temp_output_42_0_g831;
			float temp_output_11_0_g814 = ( ( lerpResult35_g833 * ( 1.0 / temp_output_42_0_g833 ) ) + temp_output_11_0_g833 );
			float lerpResult18_g814 = lerp( ( temp_output_8_0_g814 > temp_output_11_0_g814 ? 1.0 : 0.0 ) , ( temp_output_8_0_g814 < temp_output_11_0_g814 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g814 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g814 = lerp( temp_output_10_0_g814 , ( -0.5 * temp_output_10_0_g814 ) , lerpResult18_g814);
			float2 temp_output_6_0_g812 = ( temp_output_6_0_g814 - ( temp_output_39_0_g814 * lerpResult35_g814 ) );
			float2 temp_output_39_0_g812 = temp_output_39_0_g814;
			float temp_output_10_0_g812 = lerpResult35_g814;
			float temp_output_5_0_g812 = temp_output_5_0_g814;
			float temp_output_8_0_g812 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g812 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g812 - 0.0 ) );
			float temp_output_42_0_g814 = temp_output_42_0_g833;
			float temp_output_11_0_g812 = ( ( lerpResult35_g814 * ( 1.0 / temp_output_42_0_g814 ) ) + temp_output_11_0_g814 );
			float lerpResult18_g812 = lerp( ( temp_output_8_0_g812 > temp_output_11_0_g812 ? 1.0 : 0.0 ) , ( temp_output_8_0_g812 < temp_output_11_0_g812 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g812 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g812 = lerp( temp_output_10_0_g812 , ( -0.5 * temp_output_10_0_g812 ) , lerpResult18_g812);
			float2 temp_output_6_0_g805 = ( temp_output_6_0_g812 - ( temp_output_39_0_g812 * lerpResult35_g812 ) );
			float2 temp_output_39_0_g805 = temp_output_39_0_g812;
			float temp_output_10_0_g805 = lerpResult35_g812;
			float temp_output_5_0_g805 = temp_output_5_0_g812;
			float temp_output_8_0_g805 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g805 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g805 - 0.0 ) );
			float temp_output_42_0_g812 = temp_output_42_0_g814;
			float temp_output_11_0_g805 = ( ( lerpResult35_g812 * ( 1.0 / temp_output_42_0_g812 ) ) + temp_output_11_0_g812 );
			float lerpResult18_g805 = lerp( ( temp_output_8_0_g805 > temp_output_11_0_g805 ? 1.0 : 0.0 ) , ( temp_output_8_0_g805 < temp_output_11_0_g805 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g805 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g805 = lerp( temp_output_10_0_g805 , ( -0.5 * temp_output_10_0_g805 ) , lerpResult18_g805);
			float2 temp_output_6_0_g806 = ( temp_output_6_0_g805 - ( temp_output_39_0_g805 * lerpResult35_g805 ) );
			float2 temp_output_39_0_g806 = temp_output_39_0_g805;
			float temp_output_10_0_g806 = lerpResult35_g805;
			float temp_output_5_0_g806 = temp_output_5_0_g805;
			float temp_output_8_0_g806 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g806 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g806 - 0.0 ) );
			float temp_output_42_0_g805 = temp_output_42_0_g812;
			float temp_output_11_0_g806 = ( ( lerpResult35_g805 * ( 1.0 / temp_output_42_0_g805 ) ) + temp_output_11_0_g805 );
			float lerpResult18_g806 = lerp( ( temp_output_8_0_g806 > temp_output_11_0_g806 ? 1.0 : 0.0 ) , ( temp_output_8_0_g806 < temp_output_11_0_g806 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g806 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g806 = lerp( temp_output_10_0_g806 , ( -0.5 * temp_output_10_0_g806 ) , lerpResult18_g806);
			float2 temp_output_6_0_g807 = ( temp_output_6_0_g806 - ( temp_output_39_0_g806 * lerpResult35_g806 ) );
			float2 temp_output_39_0_g807 = temp_output_39_0_g806;
			float temp_output_10_0_g807 = lerpResult35_g806;
			float temp_output_5_0_g807 = temp_output_5_0_g806;
			float temp_output_8_0_g807 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g807 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g807 - 0.0 ) );
			float temp_output_42_0_g806 = temp_output_42_0_g805;
			float temp_output_11_0_g807 = ( ( lerpResult35_g806 * ( 1.0 / temp_output_42_0_g806 ) ) + temp_output_11_0_g806 );
			float lerpResult18_g807 = lerp( ( temp_output_8_0_g807 > temp_output_11_0_g807 ? 1.0 : 0.0 ) , ( temp_output_8_0_g807 < temp_output_11_0_g807 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g807 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g807 = lerp( temp_output_10_0_g807 , ( -0.5 * temp_output_10_0_g807 ) , lerpResult18_g807);
			float2 temp_output_6_0_g808 = ( temp_output_6_0_g807 - ( temp_output_39_0_g807 * lerpResult35_g807 ) );
			float2 temp_output_39_0_g808 = temp_output_39_0_g807;
			float temp_output_10_0_g808 = lerpResult35_g807;
			float temp_output_5_0_g808 = temp_output_5_0_g807;
			float temp_output_8_0_g808 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g808 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g808 - 0.0 ) );
			float temp_output_42_0_g807 = temp_output_42_0_g806;
			float temp_output_11_0_g808 = ( ( lerpResult35_g807 * ( 1.0 / temp_output_42_0_g807 ) ) + temp_output_11_0_g807 );
			float lerpResult18_g808 = lerp( ( temp_output_8_0_g808 > temp_output_11_0_g808 ? 1.0 : 0.0 ) , ( temp_output_8_0_g808 < temp_output_11_0_g808 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g808 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g808 = lerp( temp_output_10_0_g808 , ( -0.5 * temp_output_10_0_g808 ) , lerpResult18_g808);
			float2 temp_output_6_0_g810 = ( temp_output_6_0_g808 - ( temp_output_39_0_g808 * lerpResult35_g808 ) );
			float2 temp_output_39_0_g810 = temp_output_39_0_g808;
			float temp_output_10_0_g810 = lerpResult35_g808;
			float temp_output_5_0_g810 = temp_output_5_0_g808;
			float temp_output_8_0_g810 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g810 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g810 - 0.0 ) );
			float temp_output_42_0_g808 = temp_output_42_0_g807;
			float temp_output_11_0_g810 = ( ( lerpResult35_g808 * ( 1.0 / temp_output_42_0_g808 ) ) + temp_output_11_0_g808 );
			float lerpResult18_g810 = lerp( ( temp_output_8_0_g810 > temp_output_11_0_g810 ? 1.0 : 0.0 ) , ( temp_output_8_0_g810 < temp_output_11_0_g810 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g810 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g810 = lerp( temp_output_10_0_g810 , ( -0.5 * temp_output_10_0_g810 ) , lerpResult18_g810);
			float2 temp_output_6_0_g813 = ( temp_output_6_0_g810 - ( temp_output_39_0_g810 * lerpResult35_g810 ) );
			float2 temp_output_39_0_g813 = temp_output_39_0_g810;
			float temp_output_10_0_g813 = lerpResult35_g810;
			float temp_output_5_0_g813 = temp_output_5_0_g810;
			float temp_output_8_0_g813 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g813 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g813 - 0.0 ) );
			float temp_output_42_0_g810 = temp_output_42_0_g808;
			float temp_output_11_0_g813 = ( ( lerpResult35_g810 * ( 1.0 / temp_output_42_0_g810 ) ) + temp_output_11_0_g810 );
			float lerpResult18_g813 = lerp( ( temp_output_8_0_g813 > temp_output_11_0_g813 ? 1.0 : 0.0 ) , ( temp_output_8_0_g813 < temp_output_11_0_g813 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g813 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g813 = lerp( temp_output_10_0_g813 , ( -0.5 * temp_output_10_0_g813 ) , lerpResult18_g813);
			float2 temp_output_6_0_g809 = ( temp_output_6_0_g813 - ( temp_output_39_0_g813 * lerpResult35_g813 ) );
			float2 temp_output_39_0_g809 = temp_output_39_0_g813;
			float temp_output_10_0_g809 = lerpResult35_g813;
			float temp_output_5_0_g809 = temp_output_5_0_g813;
			float temp_output_8_0_g809 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g809 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g809 - 0.0 ) );
			float temp_output_42_0_g813 = temp_output_42_0_g810;
			float temp_output_11_0_g809 = ( ( lerpResult35_g813 * ( 1.0 / temp_output_42_0_g813 ) ) + temp_output_11_0_g813 );
			float lerpResult18_g809 = lerp( ( temp_output_8_0_g809 > temp_output_11_0_g809 ? 1.0 : 0.0 ) , ( temp_output_8_0_g809 < temp_output_11_0_g809 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g809 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g809 = lerp( temp_output_10_0_g809 , ( -0.5 * temp_output_10_0_g809 ) , lerpResult18_g809);
			float2 temp_output_6_0_g811 = ( temp_output_6_0_g809 - ( temp_output_39_0_g809 * lerpResult35_g809 ) );
			float2 temp_output_39_0_g811 = temp_output_39_0_g809;
			float temp_output_10_0_g811 = lerpResult35_g809;
			float temp_output_5_0_g811 = temp_output_5_0_g809;
			float temp_output_8_0_g811 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g811 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g811 - 0.0 ) );
			float temp_output_42_0_g809 = temp_output_42_0_g813;
			float temp_output_11_0_g811 = ( ( lerpResult35_g809 * ( 1.0 / temp_output_42_0_g809 ) ) + temp_output_11_0_g809 );
			float lerpResult18_g811 = lerp( ( temp_output_8_0_g811 > temp_output_11_0_g811 ? 1.0 : 0.0 ) , ( temp_output_8_0_g811 < temp_output_11_0_g811 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g811 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g811 = lerp( temp_output_10_0_g811 , ( -0.5 * temp_output_10_0_g811 ) , lerpResult18_g811);
			float2 temp_output_6_0_g803 = ( temp_output_6_0_g811 - ( temp_output_39_0_g811 * lerpResult35_g811 ) );
			float2 temp_output_39_0_g803 = temp_output_39_0_g811;
			float temp_output_10_0_g803 = lerpResult35_g811;
			float temp_output_5_0_g803 = temp_output_5_0_g811;
			float temp_output_8_0_g803 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g803 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g803 - 0.0 ) );
			float temp_output_42_0_g811 = temp_output_42_0_g809;
			float temp_output_11_0_g803 = ( ( lerpResult35_g811 * ( 1.0 / temp_output_42_0_g811 ) ) + temp_output_11_0_g811 );
			float lerpResult18_g803 = lerp( ( temp_output_8_0_g803 > temp_output_11_0_g803 ? 1.0 : 0.0 ) , ( temp_output_8_0_g803 < temp_output_11_0_g803 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g803 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g803 = lerp( temp_output_10_0_g803 , ( -0.5 * temp_output_10_0_g803 ) , lerpResult18_g803);
			float2 temp_output_6_0_g801 = ( temp_output_6_0_g803 - ( temp_output_39_0_g803 * lerpResult35_g803 ) );
			float2 temp_output_39_0_g801 = temp_output_39_0_g803;
			float temp_output_10_0_g801 = lerpResult35_g803;
			float temp_output_5_0_g801 = temp_output_5_0_g803;
			float temp_output_8_0_g801 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g801 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g801 - 0.0 ) );
			float temp_output_42_0_g803 = temp_output_42_0_g811;
			float temp_output_11_0_g801 = ( ( lerpResult35_g803 * ( 1.0 / temp_output_42_0_g803 ) ) + temp_output_11_0_g803 );
			float lerpResult18_g801 = lerp( ( temp_output_8_0_g801 > temp_output_11_0_g801 ? 1.0 : 0.0 ) , ( temp_output_8_0_g801 < temp_output_11_0_g801 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g801 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g801 = lerp( temp_output_10_0_g801 , ( -0.5 * temp_output_10_0_g801 ) , lerpResult18_g801);
			float2 temp_output_6_0_g794 = ( temp_output_6_0_g801 - ( temp_output_39_0_g801 * lerpResult35_g801 ) );
			float2 temp_output_39_0_g794 = temp_output_39_0_g801;
			float temp_output_10_0_g794 = lerpResult35_g801;
			float temp_output_5_0_g794 = temp_output_5_0_g801;
			float temp_output_8_0_g794 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g794 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g794 - 0.0 ) );
			float temp_output_42_0_g801 = temp_output_42_0_g803;
			float temp_output_11_0_g794 = ( ( lerpResult35_g801 * ( 1.0 / temp_output_42_0_g801 ) ) + temp_output_11_0_g801 );
			float lerpResult18_g794 = lerp( ( temp_output_8_0_g794 > temp_output_11_0_g794 ? 1.0 : 0.0 ) , ( temp_output_8_0_g794 < temp_output_11_0_g794 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g794 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g794 = lerp( temp_output_10_0_g794 , ( -0.5 * temp_output_10_0_g794 ) , lerpResult18_g794);
			float2 temp_output_6_0_g795 = ( temp_output_6_0_g794 - ( temp_output_39_0_g794 * lerpResult35_g794 ) );
			float2 temp_output_39_0_g795 = temp_output_39_0_g794;
			float temp_output_10_0_g795 = lerpResult35_g794;
			float temp_output_5_0_g795 = temp_output_5_0_g794;
			float temp_output_8_0_g795 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g795 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g795 - 0.0 ) );
			float temp_output_42_0_g794 = temp_output_42_0_g801;
			float temp_output_11_0_g795 = ( ( lerpResult35_g794 * ( 1.0 / temp_output_42_0_g794 ) ) + temp_output_11_0_g794 );
			float lerpResult18_g795 = lerp( ( temp_output_8_0_g795 > temp_output_11_0_g795 ? 1.0 : 0.0 ) , ( temp_output_8_0_g795 < temp_output_11_0_g795 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g795 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g795 = lerp( temp_output_10_0_g795 , ( -0.5 * temp_output_10_0_g795 ) , lerpResult18_g795);
			float2 temp_output_6_0_g796 = ( temp_output_6_0_g795 - ( temp_output_39_0_g795 * lerpResult35_g795 ) );
			float2 temp_output_39_0_g796 = temp_output_39_0_g795;
			float temp_output_10_0_g796 = lerpResult35_g795;
			float temp_output_5_0_g796 = temp_output_5_0_g795;
			float temp_output_8_0_g796 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g796 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g796 - 0.0 ) );
			float temp_output_42_0_g795 = temp_output_42_0_g794;
			float temp_output_11_0_g796 = ( ( lerpResult35_g795 * ( 1.0 / temp_output_42_0_g795 ) ) + temp_output_11_0_g795 );
			float lerpResult18_g796 = lerp( ( temp_output_8_0_g796 > temp_output_11_0_g796 ? 1.0 : 0.0 ) , ( temp_output_8_0_g796 < temp_output_11_0_g796 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g796 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g796 = lerp( temp_output_10_0_g796 , ( -0.5 * temp_output_10_0_g796 ) , lerpResult18_g796);
			float2 temp_output_6_0_g797 = ( temp_output_6_0_g796 - ( temp_output_39_0_g796 * lerpResult35_g796 ) );
			float2 temp_output_39_0_g797 = temp_output_39_0_g796;
			float temp_output_10_0_g797 = lerpResult35_g796;
			float temp_output_5_0_g797 = temp_output_5_0_g796;
			float temp_output_8_0_g797 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g797 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g797 - 0.0 ) );
			float temp_output_42_0_g796 = temp_output_42_0_g795;
			float temp_output_11_0_g797 = ( ( lerpResult35_g796 * ( 1.0 / temp_output_42_0_g796 ) ) + temp_output_11_0_g796 );
			float lerpResult18_g797 = lerp( ( temp_output_8_0_g797 > temp_output_11_0_g797 ? 1.0 : 0.0 ) , ( temp_output_8_0_g797 < temp_output_11_0_g797 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g797 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g797 = lerp( temp_output_10_0_g797 , ( -0.5 * temp_output_10_0_g797 ) , lerpResult18_g797);
			float2 temp_output_6_0_g799 = ( temp_output_6_0_g797 - ( temp_output_39_0_g797 * lerpResult35_g797 ) );
			float2 temp_output_39_0_g799 = temp_output_39_0_g797;
			float temp_output_10_0_g799 = lerpResult35_g797;
			float temp_output_5_0_g799 = temp_output_5_0_g797;
			float temp_output_8_0_g799 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g799 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g799 - 0.0 ) );
			float temp_output_42_0_g797 = temp_output_42_0_g796;
			float temp_output_11_0_g799 = ( ( lerpResult35_g797 * ( 1.0 / temp_output_42_0_g797 ) ) + temp_output_11_0_g797 );
			float lerpResult18_g799 = lerp( ( temp_output_8_0_g799 > temp_output_11_0_g799 ? 1.0 : 0.0 ) , ( temp_output_8_0_g799 < temp_output_11_0_g799 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g799 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g799 = lerp( temp_output_10_0_g799 , ( -0.5 * temp_output_10_0_g799 ) , lerpResult18_g799);
			float2 temp_output_6_0_g802 = ( temp_output_6_0_g799 - ( temp_output_39_0_g799 * lerpResult35_g799 ) );
			float2 temp_output_39_0_g802 = temp_output_39_0_g799;
			float temp_output_10_0_g802 = lerpResult35_g799;
			float temp_output_5_0_g802 = temp_output_5_0_g799;
			float temp_output_8_0_g802 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g802 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g802 - 0.0 ) );
			float temp_output_42_0_g799 = temp_output_42_0_g797;
			float temp_output_11_0_g802 = ( ( lerpResult35_g799 * ( 1.0 / temp_output_42_0_g799 ) ) + temp_output_11_0_g799 );
			float lerpResult18_g802 = lerp( ( temp_output_8_0_g802 > temp_output_11_0_g802 ? 1.0 : 0.0 ) , ( temp_output_8_0_g802 < temp_output_11_0_g802 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g802 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g802 = lerp( temp_output_10_0_g802 , ( -0.5 * temp_output_10_0_g802 ) , lerpResult18_g802);
			float2 temp_output_6_0_g798 = ( temp_output_6_0_g802 - ( temp_output_39_0_g802 * lerpResult35_g802 ) );
			float2 temp_output_39_0_g798 = temp_output_39_0_g802;
			float temp_output_10_0_g798 = lerpResult35_g802;
			float temp_output_5_0_g798 = temp_output_5_0_g802;
			float temp_output_8_0_g798 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g798 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g798 - 0.0 ) );
			float temp_output_42_0_g802 = temp_output_42_0_g799;
			float temp_output_11_0_g798 = ( ( lerpResult35_g802 * ( 1.0 / temp_output_42_0_g802 ) ) + temp_output_11_0_g802 );
			float lerpResult18_g798 = lerp( ( temp_output_8_0_g798 > temp_output_11_0_g798 ? 1.0 : 0.0 ) , ( temp_output_8_0_g798 < temp_output_11_0_g798 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g798 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g798 = lerp( temp_output_10_0_g798 , ( -0.5 * temp_output_10_0_g798 ) , lerpResult18_g798);
			float2 temp_output_6_0_g800 = ( temp_output_6_0_g798 - ( temp_output_39_0_g798 * lerpResult35_g798 ) );
			float2 temp_output_39_0_g800 = temp_output_39_0_g798;
			float temp_output_10_0_g800 = lerpResult35_g798;
			float temp_output_5_0_g800 = temp_output_5_0_g798;
			float temp_output_8_0_g800 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g800 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g800 - 0.0 ) );
			float temp_output_42_0_g798 = temp_output_42_0_g802;
			float temp_output_11_0_g800 = ( ( lerpResult35_g798 * ( 1.0 / temp_output_42_0_g798 ) ) + temp_output_11_0_g798 );
			float lerpResult18_g800 = lerp( ( temp_output_8_0_g800 > temp_output_11_0_g800 ? 1.0 : 0.0 ) , ( temp_output_8_0_g800 < temp_output_11_0_g800 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g800 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g800 = lerp( temp_output_10_0_g800 , ( -0.5 * temp_output_10_0_g800 ) , lerpResult18_g800);
			float2 temp_output_6_0_g825 = ( temp_output_6_0_g800 - ( temp_output_39_0_g800 * lerpResult35_g800 ) );
			float2 temp_output_39_0_g825 = temp_output_39_0_g800;
			float temp_output_10_0_g825 = lerpResult35_g800;
			float temp_output_5_0_g825 = temp_output_5_0_g800;
			float temp_output_8_0_g825 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g825 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g825 - 0.0 ) );
			float temp_output_42_0_g800 = temp_output_42_0_g798;
			float temp_output_11_0_g825 = ( ( lerpResult35_g800 * ( 1.0 / temp_output_42_0_g800 ) ) + temp_output_11_0_g800 );
			float lerpResult18_g825 = lerp( ( temp_output_8_0_g825 > temp_output_11_0_g825 ? 1.0 : 0.0 ) , ( temp_output_8_0_g825 < temp_output_11_0_g825 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g825 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g825 = lerp( temp_output_10_0_g825 , ( -0.5 * temp_output_10_0_g825 ) , lerpResult18_g825);
			float2 temp_output_6_0_g823 = ( temp_output_6_0_g825 - ( temp_output_39_0_g825 * lerpResult35_g825 ) );
			float2 temp_output_39_0_g823 = temp_output_39_0_g825;
			float temp_output_10_0_g823 = lerpResult35_g825;
			float temp_output_5_0_g823 = temp_output_5_0_g825;
			float temp_output_8_0_g823 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g823 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g823 - 0.0 ) );
			float temp_output_42_0_g825 = temp_output_42_0_g800;
			float temp_output_11_0_g823 = ( ( lerpResult35_g825 * ( 1.0 / temp_output_42_0_g825 ) ) + temp_output_11_0_g825 );
			float lerpResult18_g823 = lerp( ( temp_output_8_0_g823 > temp_output_11_0_g823 ? 1.0 : 0.0 ) , ( temp_output_8_0_g823 < temp_output_11_0_g823 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g823 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g823 = lerp( temp_output_10_0_g823 , ( -0.5 * temp_output_10_0_g823 ) , lerpResult18_g823);
			float2 temp_output_6_0_g816 = ( temp_output_6_0_g823 - ( temp_output_39_0_g823 * lerpResult35_g823 ) );
			float2 temp_output_39_0_g816 = temp_output_39_0_g823;
			float temp_output_10_0_g816 = lerpResult35_g823;
			float temp_output_5_0_g816 = temp_output_5_0_g823;
			float temp_output_8_0_g816 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g816 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g816 - 0.0 ) );
			float temp_output_42_0_g823 = temp_output_42_0_g825;
			float temp_output_11_0_g816 = ( ( lerpResult35_g823 * ( 1.0 / temp_output_42_0_g823 ) ) + temp_output_11_0_g823 );
			float lerpResult18_g816 = lerp( ( temp_output_8_0_g816 > temp_output_11_0_g816 ? 1.0 : 0.0 ) , ( temp_output_8_0_g816 < temp_output_11_0_g816 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g816 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g816 = lerp( temp_output_10_0_g816 , ( -0.5 * temp_output_10_0_g816 ) , lerpResult18_g816);
			float2 temp_output_6_0_g817 = ( temp_output_6_0_g816 - ( temp_output_39_0_g816 * lerpResult35_g816 ) );
			float2 temp_output_39_0_g817 = temp_output_39_0_g816;
			float temp_output_10_0_g817 = lerpResult35_g816;
			float temp_output_5_0_g817 = temp_output_5_0_g816;
			float temp_output_8_0_g817 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g817 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g817 - 0.0 ) );
			float temp_output_42_0_g816 = temp_output_42_0_g823;
			float temp_output_11_0_g817 = ( ( lerpResult35_g816 * ( 1.0 / temp_output_42_0_g816 ) ) + temp_output_11_0_g816 );
			float lerpResult18_g817 = lerp( ( temp_output_8_0_g817 > temp_output_11_0_g817 ? 1.0 : 0.0 ) , ( temp_output_8_0_g817 < temp_output_11_0_g817 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g817 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g817 = lerp( temp_output_10_0_g817 , ( -0.5 * temp_output_10_0_g817 ) , lerpResult18_g817);
			float2 temp_output_6_0_g818 = ( temp_output_6_0_g817 - ( temp_output_39_0_g817 * lerpResult35_g817 ) );
			float2 temp_output_39_0_g818 = temp_output_39_0_g817;
			float temp_output_10_0_g818 = lerpResult35_g817;
			float temp_output_5_0_g818 = temp_output_5_0_g817;
			float temp_output_8_0_g818 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g818 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g818 - 0.0 ) );
			float temp_output_42_0_g817 = temp_output_42_0_g816;
			float temp_output_11_0_g818 = ( ( lerpResult35_g817 * ( 1.0 / temp_output_42_0_g817 ) ) + temp_output_11_0_g817 );
			float lerpResult18_g818 = lerp( ( temp_output_8_0_g818 > temp_output_11_0_g818 ? 1.0 : 0.0 ) , ( temp_output_8_0_g818 < temp_output_11_0_g818 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g818 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g818 = lerp( temp_output_10_0_g818 , ( -0.5 * temp_output_10_0_g818 ) , lerpResult18_g818);
			float2 temp_output_6_0_g819 = ( temp_output_6_0_g818 - ( temp_output_39_0_g818 * lerpResult35_g818 ) );
			float2 temp_output_39_0_g819 = temp_output_39_0_g818;
			float temp_output_10_0_g819 = lerpResult35_g818;
			float temp_output_5_0_g819 = temp_output_5_0_g818;
			float temp_output_8_0_g819 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g819 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g819 - 0.0 ) );
			float temp_output_42_0_g818 = temp_output_42_0_g817;
			float temp_output_11_0_g819 = ( ( lerpResult35_g818 * ( 1.0 / temp_output_42_0_g818 ) ) + temp_output_11_0_g818 );
			float lerpResult18_g819 = lerp( ( temp_output_8_0_g819 > temp_output_11_0_g819 ? 1.0 : 0.0 ) , ( temp_output_8_0_g819 < temp_output_11_0_g819 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g819 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g819 = lerp( temp_output_10_0_g819 , ( -0.5 * temp_output_10_0_g819 ) , lerpResult18_g819);
			float2 temp_output_6_0_g821 = ( temp_output_6_0_g819 - ( temp_output_39_0_g819 * lerpResult35_g819 ) );
			float2 temp_output_39_0_g821 = temp_output_39_0_g819;
			float temp_output_10_0_g821 = lerpResult35_g819;
			float temp_output_5_0_g821 = temp_output_5_0_g819;
			float temp_output_8_0_g821 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g821 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g821 - 0.0 ) );
			float temp_output_42_0_g819 = temp_output_42_0_g818;
			float temp_output_11_0_g821 = ( ( lerpResult35_g819 * ( 1.0 / temp_output_42_0_g819 ) ) + temp_output_11_0_g819 );
			float lerpResult18_g821 = lerp( ( temp_output_8_0_g821 > temp_output_11_0_g821 ? 1.0 : 0.0 ) , ( temp_output_8_0_g821 < temp_output_11_0_g821 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g821 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g821 = lerp( temp_output_10_0_g821 , ( -0.5 * temp_output_10_0_g821 ) , lerpResult18_g821);
			float2 temp_output_6_0_g824 = ( temp_output_6_0_g821 - ( temp_output_39_0_g821 * lerpResult35_g821 ) );
			float2 temp_output_39_0_g824 = temp_output_39_0_g821;
			float temp_output_10_0_g824 = lerpResult35_g821;
			float temp_output_5_0_g824 = temp_output_5_0_g821;
			float temp_output_8_0_g824 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g824 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g824 - 0.0 ) );
			float temp_output_42_0_g821 = temp_output_42_0_g819;
			float temp_output_11_0_g824 = ( ( lerpResult35_g821 * ( 1.0 / temp_output_42_0_g821 ) ) + temp_output_11_0_g821 );
			float lerpResult18_g824 = lerp( ( temp_output_8_0_g824 > temp_output_11_0_g824 ? 1.0 : 0.0 ) , ( temp_output_8_0_g824 < temp_output_11_0_g824 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g824 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g824 = lerp( temp_output_10_0_g824 , ( -0.5 * temp_output_10_0_g824 ) , lerpResult18_g824);
			float2 temp_output_6_0_g820 = ( temp_output_6_0_g824 - ( temp_output_39_0_g824 * lerpResult35_g824 ) );
			float2 temp_output_39_0_g820 = temp_output_39_0_g824;
			float temp_output_10_0_g820 = lerpResult35_g824;
			float temp_output_5_0_g820 = temp_output_5_0_g824;
			float temp_output_8_0_g820 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g820 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g820 - 0.0 ) );
			float temp_output_42_0_g824 = temp_output_42_0_g821;
			float temp_output_11_0_g820 = ( ( lerpResult35_g824 * ( 1.0 / temp_output_42_0_g824 ) ) + temp_output_11_0_g824 );
			float lerpResult18_g820 = lerp( ( temp_output_8_0_g820 > temp_output_11_0_g820 ? 1.0 : 0.0 ) , ( temp_output_8_0_g820 < temp_output_11_0_g820 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g820 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g820 = lerp( temp_output_10_0_g820 , ( -0.5 * temp_output_10_0_g820 ) , lerpResult18_g820);
			float2 temp_output_6_0_g822 = ( temp_output_6_0_g820 - ( temp_output_39_0_g820 * lerpResult35_g820 ) );
			float2 temp_output_39_0_g822 = temp_output_39_0_g820;
			float temp_output_10_0_g822 = lerpResult35_g820;
			float temp_output_5_0_g822 = temp_output_5_0_g820;
			float temp_output_8_0_g822 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g822 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g822 - 0.0 ) );
			float temp_output_42_0_g820 = temp_output_42_0_g824;
			float temp_output_11_0_g822 = ( ( lerpResult35_g820 * ( 1.0 / temp_output_42_0_g820 ) ) + temp_output_11_0_g820 );
			float lerpResult18_g822 = lerp( ( temp_output_8_0_g822 > temp_output_11_0_g822 ? 1.0 : 0.0 ) , ( temp_output_8_0_g822 < temp_output_11_0_g822 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g822 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g822 = lerp( temp_output_10_0_g822 , ( -0.5 * temp_output_10_0_g822 ) , lerpResult18_g822);
			float3 break3_g1168 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _ddna, sampler_ddna, ( temp_output_6_0_g822 - ( temp_output_39_0_g822 * lerpResult35_g822 ) ) ), 1.0 );
			float3 appendResult6_g1168 = (float3(( break3_g1168.y * 1.0 ) , ( break3_g1168.x * -1.0 ) , break3_g1168.z));
			o.Normal = appendResult6_g1168;
			o.Albedo = saturate( ( SAMPLE_TEXTURE2D( _Specular, sampler_Specular, ( temp_output_6_0_g822 - ( temp_output_39_0_g822 * lerpResult35_g822 ) ) ).rgb + _Brightness ) );
			float4 tex2DNode21 = SAMPLE_TEXTURE2D( _Diffuse, sampler_Diffuse, ( temp_output_6_0_g822 - ( temp_output_39_0_g822 * lerpResult35_g822 ) ) );
			float temp_output_28_0 = saturate( ( tex2DNode21.a - SAMPLE_TEXTURE2D( _DDNAGlossmap, sampler_DDNAGlossmap, ( temp_output_6_0_g822 - ( temp_output_39_0_g822 * lerpResult35_g822 ) ) ).b ) );
			float dynamicSwitch42 = ( float )0;
			UNITY_BRANCH if ( _INVERTROUGHNESS_ON )
			{
				dynamicSwitch42 =  (0.0 + ( temp_output_28_0 - 1.0 ) * ( 1.0 - 0.0 ) / ( 0.0 - 1.0 ) );
			}
			else
			{
				dynamicSwitch42 = temp_output_28_0;
			}
			o.Smoothness = dynamicSwitch42;
			o.Alpha = saturate( ( tex2DNode21.a - saturate( ( _AlphaMidLevelControl + tex2DNode21.r ) ) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19904
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-1632,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-1760,-272;Inherit;False;Property;_NonPlanar;Non-Planar;9;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-1808,176;Inherit;False;Property;_Bias;Bias;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-1568,-272;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-1568,-112;Inherit;False;Property;_Scale;Scale;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-1488,176;Inherit;False;Property;_InvertBias;Invert Bias;8;0;Create;True;0;0;0;False;0;False;2;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;-1696,-192;Inherit;False;Property;_Layers;Layers;7;0;Create;True;0;0;0;False;0;False;40;40;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-1696,-32;Inherit;True;Property;_Disp;Disp;4;0;Create;True;0;0;0;False;0;False;None;c4ca86660422cfe4d8947b7cb44acea9;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-608,-336;Inherit;False;Property;_AlphaMidLevelControl;Alpha Mid-Level Control;10;0;Create;True;0;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-1168,-16;Inherit;False;SC POM Vector;-1;;749;b885b1e06f194f340908e3767f9051ad;0;6;4;FLOAT;1;False;9;FLOAT;40;False;10;FLOAT;1;False;26;SAMPLER2D;0;False;27;FLOAT;0.74;False;28;SAMPLERSTATE;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-336,-336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-880,-16;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;21;-640,-224;Inherit;True;Property;_Diffuse;Diffuse;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-640,16;Inherit;True;Property;_DDNAGlossmap;DDNA Glossmap;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-320,32;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-816,304;Inherit;False;Constant;_nStrength;n Strength;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-224,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-576,672;Inherit;False;Property;_Brightness;Brightness;12;0;Create;True;0;0;0;False;0;False;-0.75;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-640,464;Inherit;True;Property;_Specular;Specular;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;-176,32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-16,32;Inherit;False;SC Roughness Global;-1;;1167;72bbef7413bedc64a9a1e5c76026517c;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-256,480;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;-0.75;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;-640,240;Inherit;True;Property;_ddna;ddna;1;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-48,-336;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;128,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-336,240;Inherit;False;SC Flip Normals;-1;;1168;3db8caf25439b804b879d6fa5563dc3d;0;1;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-80,-96;Inherit;False;Property;_InvertRoughness;Invert Roughness;11;0;Create;True;0;0;0;False;0;False;2;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;300.2427,-222.4164;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-128,480;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-1203.991,422.4698;Inherit;False;Constant;_MetalTweak;Metal Tweak;13;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-976,-272;Inherit;False;Constant;_DiffuseColor;Diffuse Color;13;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-1088,224;Inherit;False;Constant;_DDNAColor;DDNA Color;13;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,0.9686275;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-112,-256;Inherit;False;Property;_BaseColor;Base Color;13;0;Create;True;0;0;0;True;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;-2.412231,320.7086;Inherit;False;Property;_Emission;Emission;14;0;Create;True;0;0;0;True;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;176.0416,579.9225;Inherit;False;Property;_SpecularColor;Specular Color;15;0;Create;True;0;0;0;True;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;320,-80;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/Decals POM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;True;False;Back;2;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.01;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;1;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;8;0
WireConnection;19;0;18;0
WireConnection;14;1;8;0
WireConnection;14;0;12;0
WireConnection;82;4;19;0
WireConnection;82;9;78;0
WireConnection;82;10;7;0
WireConnection;82;26;9;0
WireConnection;82;27;14;0
WireConnection;82;28;9;1
WireConnection;34;0;33;0
WireConnection;34;1;21;1
WireConnection;20;0;82;0
WireConnection;21;1;20;0
WireConnection;22;1;20;0
WireConnection;27;0;21;4
WireConnection;27;1;22;3
WireConnection;35;0;34;0
WireConnection;24;1;20;0
WireConnection;28;0;27;0
WireConnection;32;1;28;0
WireConnection;39;0;24;5
WireConnection;39;1;60;0
WireConnection;23;1;20;0
WireConnection;23;5;25;0
WireConnection;36;0;21;4
WireConnection;36;1;35;0
WireConnection;37;0;36;0
WireConnection;26;1;23;0
WireConnection;42;1;28;0
WireConnection;42;0;32;0
WireConnection;58;0;59;5
WireConnection;58;1;21;4
WireConnection;41;0;39;0
WireConnection;0;0;41;0
WireConnection;0;1;26;0
WireConnection;0;4;42;0
WireConnection;0;9;37;0
ASEEND*/
//CHKSM=A1E1A85B5FE09C766C23B8A12684F9758007209A