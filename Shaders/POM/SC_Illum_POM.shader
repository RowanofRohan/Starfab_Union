// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Illum Parallax"
{
	Properties
	{
		[Gamma] _BaseColor( "Base Color", Color ) = ( 0.8, 0.8, 0.8, 1 )
		[Toggle( _FLIPGREENCHANNEL_ON )] _FlipGreenChannel( "Flip Green Channel", Float ) = 1
		_Disp( "Disp", 2D ) = "white" {}
		[Gamma] _DiffuseColor( "Diffuse Color", Color ) = ( 0.5, 0.5, 0.5, 0 )
		_Scale( "Scale", Float ) = 1
		[Gamma] _Diffuse( "Diffuse", 2D ) = "white" {}
		_Bias( "Bias", Float ) = 0.5
		_DDNAColor( "DDNA Color", Color ) = ( 0.5, 0.5, 1, 0.5019608 )
		_Layers( "Layers", Range( 1, 200 ) ) = 40
		[Normal] _ddna( "ddna", 2D ) = "bump" {}
		[Toggle( _INVERTBIAS_ON )] _InvertBias( "Invert Bias", Float ) = 0
		_NonPlanar( "Non-Planar", Int ) = 1
		_DDNAGlossmap( "DDNA Glossmap", 2D ) = "white" {}
		_SpecularColor( "Specular Color", Color ) = ( 0, 0, 0, 1 )
		_Specular( "Specular", 2D ) = "white" {}
		_DispColor( "Disp Color", Color ) = ( 0, 0, 0, 1 )
		_DetailColor( "Detail Color", Color ) = ( 0.9411765, 0.7333333, 1, 0.5019608 )
		_Detail( "Detail", 2D ) = "white" {}
		_DecalColor( "Decal Color", Color ) = ( 0, 0, 0, 0 )
		_Decal( "Decal", 2D ) = "white" {}
		_BlendColor( "Blend Color", Color ) = ( 1, 1, 1, 1 )
		_Blend( "Blend", 2D ) = "white" {}
		_BlendLayer2DiffuseColor( "Blend Layer 2 Diffuse Color", Color ) = ( 0, 0, 0, 0 )
		_BlendLayer2SpecularColor( "Blend Layer 2 Specular Color", Color ) = ( 0, 0, 0, 0 )
		_BlendLayer2Glossiness( "Blend Layer 2 Glossiness", Float ) = 0
		_BlendFactor( "Blend Factor", Float ) = 0
		_BlendFalloff( "Blend Falloff", Float ) = 0
		_Glow( "Glow", Float ) = 0
		_NormalStrength( "Normal Strength", Float ) = 1
		_UseAlpha( "Use Alpha", Float ) = 0
		_HeightBias( "Height Bias", Float ) = 0.5
		_POMDisplacement( "POM Displacement", Float ) = 0
		_DetailDiffuseScale( "Detail Diffuse Scale", Float ) = 0
		_DetailGlossScale( "Detail Gloss Scale", Float ) = 0
		_Emission( "_Emission", Color ) = ( 0, 0, 0, 0 )
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] GenKey__Specular( "Assign keyword _SPECULAR", Float ) = 1.0
		[HideInInspector] GenKey__Blend( "Assign keyword _BLEND", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse( "Assign keyword _DIFFUSE", Float ) = 1.0
		[HideInInspector] GenKey__Detail( "Assign keyword _DETAIL", Float ) = 1.0
		[HideInInspector] GenKey__ddna( "Assign keyword _DDNA", Float ) = 1.0
		[HideInInspector] GenKey__Decal( "Assign keyword _DECAL", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap( "Assign keyword _DDNAGLOSSMAP", Float ) = 1.0
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityStandardBRDF.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma dynamic_branch _DDNA
		#pragma dynamic_branch _INVERTBIAS_ON
		#pragma dynamic_branch _DETAIL
		#pragma shader_feature_local _FLIPGREENCHANNEL_ON
		#pragma dynamic_branch _BLEND
		#pragma dynamic_branch _DISP
		#pragma dynamic_branch _DIFFUSE
		#pragma dynamic_branch _DECAL
		#pragma dynamic_branch _SPECULAR
		#pragma dynamic_branch _DDNAGLOSSMAP
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
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Emission;
		uniform float4 _DDNAColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ddna);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Disp);
		uniform float4 _Disp_ST;
		uniform int _NonPlanar;
		uniform float _Scale;
		uniform float _Layers;
		SamplerState sampler_Disp;
		uniform float _Bias;
		SamplerState sampler_ddna;
		uniform float _NormalStrength;
		uniform float4 _DetailColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail);
		SamplerState sampler_Detail;
		uniform float4 _BlendColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Blend);
		SamplerState sampler_Blend;
		uniform float _BlendFactor;
		uniform float _BlendFalloff;
		uniform float _POMDisplacement;
		uniform float4 _DispColor;
		uniform float _HeightBias;
		uniform float4 _BaseColor;
		uniform float4 _DiffuseColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Diffuse);
		SamplerState sampler_Diffuse;
		uniform float4 _BlendLayer2DiffuseColor;
		uniform float _DetailDiffuseScale;
		uniform float4 _DecalColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Decal);
		SamplerState sampler_Decal;
		uniform float _Glow;
		uniform float4 _SpecularColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Specular);
		SamplerState sampler_Specular;
		uniform float4 _BlendLayer2SpecularColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DDNAGlossmap);
		SamplerState sampler_DDNAGlossmap;
		uniform float _BlendLayer2Glossiness;
		uniform float _DetailGlossScale;
		uniform float _UseAlpha;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Disp = i.uv_texcoord * _Disp_ST.xy + _Disp_ST.zw;
			float2 temp_output_6_0_g61548 = uv_Disp;
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
			float3 lerpResult3_g61504 = lerp( ase_viewDirSafeWS , Unity_SafeNormalize( i.viewDir ) , (float)saturate( _NonPlanar ));
			float3 break6_g61504 = lerpResult3_g61504;
			float2 appendResult101_g61504 = (float2(break6_g61504.x , break6_g61504.y));
			float temp_output_9_0_g61504 = _Layers;
			float2 temp_output_39_0_g61548 = ( ( ( appendResult101_g61504 / break6_g61504.z ) * ( _Scale / temp_output_9_0_g61504 ) ) / temp_output_9_0_g61504 );
			float temp_output_10_0_g61548 = 1.0;
			float dynamicSwitch48 = ( float )0;
			UNITY_BRANCH if ( _INVERTBIAS_ON )
			{
				dynamicSwitch48 = ( 1.0 - _Bias );
			}
			else
			{
				dynamicSwitch48 = _Bias;
			}
			float temp_output_5_0_g61548 = dynamicSwitch48;
			float temp_output_8_0_g61548 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61548 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61548 - 0.0 ) );
			float temp_output_11_0_g61548 = 0.0;
			float lerpResult18_g61548 = lerp( ( temp_output_8_0_g61548 > temp_output_11_0_g61548 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61548 < temp_output_11_0_g61548 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61548 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61548 = lerp( temp_output_10_0_g61548 , ( -0.5 * temp_output_10_0_g61548 ) , lerpResult18_g61548);
			float2 temp_output_6_0_g61546 = ( temp_output_6_0_g61548 - ( temp_output_39_0_g61548 * lerpResult35_g61548 ) );
			float2 temp_output_39_0_g61546 = temp_output_39_0_g61548;
			float temp_output_10_0_g61546 = lerpResult35_g61548;
			float temp_output_5_0_g61546 = temp_output_5_0_g61548;
			float temp_output_8_0_g61546 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61546 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61546 - 0.0 ) );
			float temp_output_42_0_g61548 = temp_output_9_0_g61504;
			float temp_output_11_0_g61546 = ( ( lerpResult35_g61548 * ( 1.0 / temp_output_42_0_g61548 ) ) + temp_output_11_0_g61548 );
			float lerpResult18_g61546 = lerp( ( temp_output_8_0_g61546 > temp_output_11_0_g61546 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61546 < temp_output_11_0_g61546 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61546 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61546 = lerp( temp_output_10_0_g61546 , ( -0.5 * temp_output_10_0_g61546 ) , lerpResult18_g61546);
			float2 temp_output_6_0_g61539 = ( temp_output_6_0_g61546 - ( temp_output_39_0_g61546 * lerpResult35_g61546 ) );
			float2 temp_output_39_0_g61539 = temp_output_39_0_g61546;
			float temp_output_10_0_g61539 = lerpResult35_g61546;
			float temp_output_5_0_g61539 = temp_output_5_0_g61546;
			float temp_output_8_0_g61539 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61539 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61539 - 0.0 ) );
			float temp_output_42_0_g61546 = temp_output_42_0_g61548;
			float temp_output_11_0_g61539 = ( ( lerpResult35_g61546 * ( 1.0 / temp_output_42_0_g61546 ) ) + temp_output_11_0_g61546 );
			float lerpResult18_g61539 = lerp( ( temp_output_8_0_g61539 > temp_output_11_0_g61539 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61539 < temp_output_11_0_g61539 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61539 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61539 = lerp( temp_output_10_0_g61539 , ( -0.5 * temp_output_10_0_g61539 ) , lerpResult18_g61539);
			float2 temp_output_6_0_g61540 = ( temp_output_6_0_g61539 - ( temp_output_39_0_g61539 * lerpResult35_g61539 ) );
			float2 temp_output_39_0_g61540 = temp_output_39_0_g61539;
			float temp_output_10_0_g61540 = lerpResult35_g61539;
			float temp_output_5_0_g61540 = temp_output_5_0_g61539;
			float temp_output_8_0_g61540 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61540 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61540 - 0.0 ) );
			float temp_output_42_0_g61539 = temp_output_42_0_g61546;
			float temp_output_11_0_g61540 = ( ( lerpResult35_g61539 * ( 1.0 / temp_output_42_0_g61539 ) ) + temp_output_11_0_g61539 );
			float lerpResult18_g61540 = lerp( ( temp_output_8_0_g61540 > temp_output_11_0_g61540 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61540 < temp_output_11_0_g61540 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61540 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61540 = lerp( temp_output_10_0_g61540 , ( -0.5 * temp_output_10_0_g61540 ) , lerpResult18_g61540);
			float2 temp_output_6_0_g61541 = ( temp_output_6_0_g61540 - ( temp_output_39_0_g61540 * lerpResult35_g61540 ) );
			float2 temp_output_39_0_g61541 = temp_output_39_0_g61540;
			float temp_output_10_0_g61541 = lerpResult35_g61540;
			float temp_output_5_0_g61541 = temp_output_5_0_g61540;
			float temp_output_8_0_g61541 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61541 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61541 - 0.0 ) );
			float temp_output_42_0_g61540 = temp_output_42_0_g61539;
			float temp_output_11_0_g61541 = ( ( lerpResult35_g61540 * ( 1.0 / temp_output_42_0_g61540 ) ) + temp_output_11_0_g61540 );
			float lerpResult18_g61541 = lerp( ( temp_output_8_0_g61541 > temp_output_11_0_g61541 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61541 < temp_output_11_0_g61541 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61541 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61541 = lerp( temp_output_10_0_g61541 , ( -0.5 * temp_output_10_0_g61541 ) , lerpResult18_g61541);
			float2 temp_output_6_0_g61542 = ( temp_output_6_0_g61541 - ( temp_output_39_0_g61541 * lerpResult35_g61541 ) );
			float2 temp_output_39_0_g61542 = temp_output_39_0_g61541;
			float temp_output_10_0_g61542 = lerpResult35_g61541;
			float temp_output_5_0_g61542 = temp_output_5_0_g61541;
			float temp_output_8_0_g61542 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61542 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61542 - 0.0 ) );
			float temp_output_42_0_g61541 = temp_output_42_0_g61540;
			float temp_output_11_0_g61542 = ( ( lerpResult35_g61541 * ( 1.0 / temp_output_42_0_g61541 ) ) + temp_output_11_0_g61541 );
			float lerpResult18_g61542 = lerp( ( temp_output_8_0_g61542 > temp_output_11_0_g61542 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61542 < temp_output_11_0_g61542 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61542 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61542 = lerp( temp_output_10_0_g61542 , ( -0.5 * temp_output_10_0_g61542 ) , lerpResult18_g61542);
			float2 temp_output_6_0_g61544 = ( temp_output_6_0_g61542 - ( temp_output_39_0_g61542 * lerpResult35_g61542 ) );
			float2 temp_output_39_0_g61544 = temp_output_39_0_g61542;
			float temp_output_10_0_g61544 = lerpResult35_g61542;
			float temp_output_5_0_g61544 = temp_output_5_0_g61542;
			float temp_output_8_0_g61544 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61544 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61544 - 0.0 ) );
			float temp_output_42_0_g61542 = temp_output_42_0_g61541;
			float temp_output_11_0_g61544 = ( ( lerpResult35_g61542 * ( 1.0 / temp_output_42_0_g61542 ) ) + temp_output_11_0_g61542 );
			float lerpResult18_g61544 = lerp( ( temp_output_8_0_g61544 > temp_output_11_0_g61544 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61544 < temp_output_11_0_g61544 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61544 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61544 = lerp( temp_output_10_0_g61544 , ( -0.5 * temp_output_10_0_g61544 ) , lerpResult18_g61544);
			float2 temp_output_6_0_g61547 = ( temp_output_6_0_g61544 - ( temp_output_39_0_g61544 * lerpResult35_g61544 ) );
			float2 temp_output_39_0_g61547 = temp_output_39_0_g61544;
			float temp_output_10_0_g61547 = lerpResult35_g61544;
			float temp_output_5_0_g61547 = temp_output_5_0_g61544;
			float temp_output_8_0_g61547 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61547 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61547 - 0.0 ) );
			float temp_output_42_0_g61544 = temp_output_42_0_g61542;
			float temp_output_11_0_g61547 = ( ( lerpResult35_g61544 * ( 1.0 / temp_output_42_0_g61544 ) ) + temp_output_11_0_g61544 );
			float lerpResult18_g61547 = lerp( ( temp_output_8_0_g61547 > temp_output_11_0_g61547 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61547 < temp_output_11_0_g61547 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61547 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61547 = lerp( temp_output_10_0_g61547 , ( -0.5 * temp_output_10_0_g61547 ) , lerpResult18_g61547);
			float2 temp_output_6_0_g61543 = ( temp_output_6_0_g61547 - ( temp_output_39_0_g61547 * lerpResult35_g61547 ) );
			float2 temp_output_39_0_g61543 = temp_output_39_0_g61547;
			float temp_output_10_0_g61543 = lerpResult35_g61547;
			float temp_output_5_0_g61543 = temp_output_5_0_g61547;
			float temp_output_8_0_g61543 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61543 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61543 - 0.0 ) );
			float temp_output_42_0_g61547 = temp_output_42_0_g61544;
			float temp_output_11_0_g61543 = ( ( lerpResult35_g61547 * ( 1.0 / temp_output_42_0_g61547 ) ) + temp_output_11_0_g61547 );
			float lerpResult18_g61543 = lerp( ( temp_output_8_0_g61543 > temp_output_11_0_g61543 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61543 < temp_output_11_0_g61543 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61543 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61543 = lerp( temp_output_10_0_g61543 , ( -0.5 * temp_output_10_0_g61543 ) , lerpResult18_g61543);
			float2 temp_output_6_0_g61545 = ( temp_output_6_0_g61543 - ( temp_output_39_0_g61543 * lerpResult35_g61543 ) );
			float2 temp_output_39_0_g61545 = temp_output_39_0_g61543;
			float temp_output_10_0_g61545 = lerpResult35_g61543;
			float temp_output_5_0_g61545 = temp_output_5_0_g61543;
			float temp_output_8_0_g61545 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61545 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61545 - 0.0 ) );
			float temp_output_42_0_g61543 = temp_output_42_0_g61547;
			float temp_output_11_0_g61545 = ( ( lerpResult35_g61543 * ( 1.0 / temp_output_42_0_g61543 ) ) + temp_output_11_0_g61543 );
			float lerpResult18_g61545 = lerp( ( temp_output_8_0_g61545 > temp_output_11_0_g61545 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61545 < temp_output_11_0_g61545 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61545 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61545 = lerp( temp_output_10_0_g61545 , ( -0.5 * temp_output_10_0_g61545 ) , lerpResult18_g61545);
			float2 temp_output_6_0_g61526 = ( temp_output_6_0_g61545 - ( temp_output_39_0_g61545 * lerpResult35_g61545 ) );
			float2 temp_output_39_0_g61526 = temp_output_39_0_g61545;
			float temp_output_10_0_g61526 = lerpResult35_g61545;
			float temp_output_5_0_g61526 = temp_output_5_0_g61545;
			float temp_output_8_0_g61526 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61526 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61526 - 0.0 ) );
			float temp_output_42_0_g61545 = temp_output_42_0_g61543;
			float temp_output_11_0_g61526 = ( ( lerpResult35_g61545 * ( 1.0 / temp_output_42_0_g61545 ) ) + temp_output_11_0_g61545 );
			float lerpResult18_g61526 = lerp( ( temp_output_8_0_g61526 > temp_output_11_0_g61526 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61526 < temp_output_11_0_g61526 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61526 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61526 = lerp( temp_output_10_0_g61526 , ( -0.5 * temp_output_10_0_g61526 ) , lerpResult18_g61526);
			float2 temp_output_6_0_g61524 = ( temp_output_6_0_g61526 - ( temp_output_39_0_g61526 * lerpResult35_g61526 ) );
			float2 temp_output_39_0_g61524 = temp_output_39_0_g61526;
			float temp_output_10_0_g61524 = lerpResult35_g61526;
			float temp_output_5_0_g61524 = temp_output_5_0_g61526;
			float temp_output_8_0_g61524 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61524 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61524 - 0.0 ) );
			float temp_output_42_0_g61526 = temp_output_42_0_g61545;
			float temp_output_11_0_g61524 = ( ( lerpResult35_g61526 * ( 1.0 / temp_output_42_0_g61526 ) ) + temp_output_11_0_g61526 );
			float lerpResult18_g61524 = lerp( ( temp_output_8_0_g61524 > temp_output_11_0_g61524 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61524 < temp_output_11_0_g61524 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61524 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61524 = lerp( temp_output_10_0_g61524 , ( -0.5 * temp_output_10_0_g61524 ) , lerpResult18_g61524);
			float2 temp_output_6_0_g61517 = ( temp_output_6_0_g61524 - ( temp_output_39_0_g61524 * lerpResult35_g61524 ) );
			float2 temp_output_39_0_g61517 = temp_output_39_0_g61524;
			float temp_output_10_0_g61517 = lerpResult35_g61524;
			float temp_output_5_0_g61517 = temp_output_5_0_g61524;
			float temp_output_8_0_g61517 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61517 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61517 - 0.0 ) );
			float temp_output_42_0_g61524 = temp_output_42_0_g61526;
			float temp_output_11_0_g61517 = ( ( lerpResult35_g61524 * ( 1.0 / temp_output_42_0_g61524 ) ) + temp_output_11_0_g61524 );
			float lerpResult18_g61517 = lerp( ( temp_output_8_0_g61517 > temp_output_11_0_g61517 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61517 < temp_output_11_0_g61517 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61517 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61517 = lerp( temp_output_10_0_g61517 , ( -0.5 * temp_output_10_0_g61517 ) , lerpResult18_g61517);
			float2 temp_output_6_0_g61518 = ( temp_output_6_0_g61517 - ( temp_output_39_0_g61517 * lerpResult35_g61517 ) );
			float2 temp_output_39_0_g61518 = temp_output_39_0_g61517;
			float temp_output_10_0_g61518 = lerpResult35_g61517;
			float temp_output_5_0_g61518 = temp_output_5_0_g61517;
			float temp_output_8_0_g61518 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61518 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61518 - 0.0 ) );
			float temp_output_42_0_g61517 = temp_output_42_0_g61524;
			float temp_output_11_0_g61518 = ( ( lerpResult35_g61517 * ( 1.0 / temp_output_42_0_g61517 ) ) + temp_output_11_0_g61517 );
			float lerpResult18_g61518 = lerp( ( temp_output_8_0_g61518 > temp_output_11_0_g61518 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61518 < temp_output_11_0_g61518 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61518 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61518 = lerp( temp_output_10_0_g61518 , ( -0.5 * temp_output_10_0_g61518 ) , lerpResult18_g61518);
			float2 temp_output_6_0_g61519 = ( temp_output_6_0_g61518 - ( temp_output_39_0_g61518 * lerpResult35_g61518 ) );
			float2 temp_output_39_0_g61519 = temp_output_39_0_g61518;
			float temp_output_10_0_g61519 = lerpResult35_g61518;
			float temp_output_5_0_g61519 = temp_output_5_0_g61518;
			float temp_output_8_0_g61519 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61519 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61519 - 0.0 ) );
			float temp_output_42_0_g61518 = temp_output_42_0_g61517;
			float temp_output_11_0_g61519 = ( ( lerpResult35_g61518 * ( 1.0 / temp_output_42_0_g61518 ) ) + temp_output_11_0_g61518 );
			float lerpResult18_g61519 = lerp( ( temp_output_8_0_g61519 > temp_output_11_0_g61519 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61519 < temp_output_11_0_g61519 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61519 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61519 = lerp( temp_output_10_0_g61519 , ( -0.5 * temp_output_10_0_g61519 ) , lerpResult18_g61519);
			float2 temp_output_6_0_g61520 = ( temp_output_6_0_g61519 - ( temp_output_39_0_g61519 * lerpResult35_g61519 ) );
			float2 temp_output_39_0_g61520 = temp_output_39_0_g61519;
			float temp_output_10_0_g61520 = lerpResult35_g61519;
			float temp_output_5_0_g61520 = temp_output_5_0_g61519;
			float temp_output_8_0_g61520 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61520 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61520 - 0.0 ) );
			float temp_output_42_0_g61519 = temp_output_42_0_g61518;
			float temp_output_11_0_g61520 = ( ( lerpResult35_g61519 * ( 1.0 / temp_output_42_0_g61519 ) ) + temp_output_11_0_g61519 );
			float lerpResult18_g61520 = lerp( ( temp_output_8_0_g61520 > temp_output_11_0_g61520 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61520 < temp_output_11_0_g61520 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61520 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61520 = lerp( temp_output_10_0_g61520 , ( -0.5 * temp_output_10_0_g61520 ) , lerpResult18_g61520);
			float2 temp_output_6_0_g61522 = ( temp_output_6_0_g61520 - ( temp_output_39_0_g61520 * lerpResult35_g61520 ) );
			float2 temp_output_39_0_g61522 = temp_output_39_0_g61520;
			float temp_output_10_0_g61522 = lerpResult35_g61520;
			float temp_output_5_0_g61522 = temp_output_5_0_g61520;
			float temp_output_8_0_g61522 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61522 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61522 - 0.0 ) );
			float temp_output_42_0_g61520 = temp_output_42_0_g61519;
			float temp_output_11_0_g61522 = ( ( lerpResult35_g61520 * ( 1.0 / temp_output_42_0_g61520 ) ) + temp_output_11_0_g61520 );
			float lerpResult18_g61522 = lerp( ( temp_output_8_0_g61522 > temp_output_11_0_g61522 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61522 < temp_output_11_0_g61522 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61522 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61522 = lerp( temp_output_10_0_g61522 , ( -0.5 * temp_output_10_0_g61522 ) , lerpResult18_g61522);
			float2 temp_output_6_0_g61525 = ( temp_output_6_0_g61522 - ( temp_output_39_0_g61522 * lerpResult35_g61522 ) );
			float2 temp_output_39_0_g61525 = temp_output_39_0_g61522;
			float temp_output_10_0_g61525 = lerpResult35_g61522;
			float temp_output_5_0_g61525 = temp_output_5_0_g61522;
			float temp_output_8_0_g61525 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61525 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61525 - 0.0 ) );
			float temp_output_42_0_g61522 = temp_output_42_0_g61520;
			float temp_output_11_0_g61525 = ( ( lerpResult35_g61522 * ( 1.0 / temp_output_42_0_g61522 ) ) + temp_output_11_0_g61522 );
			float lerpResult18_g61525 = lerp( ( temp_output_8_0_g61525 > temp_output_11_0_g61525 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61525 < temp_output_11_0_g61525 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61525 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61525 = lerp( temp_output_10_0_g61525 , ( -0.5 * temp_output_10_0_g61525 ) , lerpResult18_g61525);
			float2 temp_output_6_0_g61521 = ( temp_output_6_0_g61525 - ( temp_output_39_0_g61525 * lerpResult35_g61525 ) );
			float2 temp_output_39_0_g61521 = temp_output_39_0_g61525;
			float temp_output_10_0_g61521 = lerpResult35_g61525;
			float temp_output_5_0_g61521 = temp_output_5_0_g61525;
			float temp_output_8_0_g61521 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61521 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61521 - 0.0 ) );
			float temp_output_42_0_g61525 = temp_output_42_0_g61522;
			float temp_output_11_0_g61521 = ( ( lerpResult35_g61525 * ( 1.0 / temp_output_42_0_g61525 ) ) + temp_output_11_0_g61525 );
			float lerpResult18_g61521 = lerp( ( temp_output_8_0_g61521 > temp_output_11_0_g61521 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61521 < temp_output_11_0_g61521 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61521 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61521 = lerp( temp_output_10_0_g61521 , ( -0.5 * temp_output_10_0_g61521 ) , lerpResult18_g61521);
			float2 temp_output_6_0_g61523 = ( temp_output_6_0_g61521 - ( temp_output_39_0_g61521 * lerpResult35_g61521 ) );
			float2 temp_output_39_0_g61523 = temp_output_39_0_g61521;
			float temp_output_10_0_g61523 = lerpResult35_g61521;
			float temp_output_5_0_g61523 = temp_output_5_0_g61521;
			float temp_output_8_0_g61523 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61523 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61523 - 0.0 ) );
			float temp_output_42_0_g61521 = temp_output_42_0_g61525;
			float temp_output_11_0_g61523 = ( ( lerpResult35_g61521 * ( 1.0 / temp_output_42_0_g61521 ) ) + temp_output_11_0_g61521 );
			float lerpResult18_g61523 = lerp( ( temp_output_8_0_g61523 > temp_output_11_0_g61523 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61523 < temp_output_11_0_g61523 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61523 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61523 = lerp( temp_output_10_0_g61523 , ( -0.5 * temp_output_10_0_g61523 ) , lerpResult18_g61523);
			float2 temp_output_6_0_g61515 = ( temp_output_6_0_g61523 - ( temp_output_39_0_g61523 * lerpResult35_g61523 ) );
			float2 temp_output_39_0_g61515 = temp_output_39_0_g61523;
			float temp_output_10_0_g61515 = lerpResult35_g61523;
			float temp_output_5_0_g61515 = temp_output_5_0_g61523;
			float temp_output_8_0_g61515 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61515 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61515 - 0.0 ) );
			float temp_output_42_0_g61523 = temp_output_42_0_g61521;
			float temp_output_11_0_g61515 = ( ( lerpResult35_g61523 * ( 1.0 / temp_output_42_0_g61523 ) ) + temp_output_11_0_g61523 );
			float lerpResult18_g61515 = lerp( ( temp_output_8_0_g61515 > temp_output_11_0_g61515 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61515 < temp_output_11_0_g61515 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61515 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61515 = lerp( temp_output_10_0_g61515 , ( -0.5 * temp_output_10_0_g61515 ) , lerpResult18_g61515);
			float2 temp_output_6_0_g61513 = ( temp_output_6_0_g61515 - ( temp_output_39_0_g61515 * lerpResult35_g61515 ) );
			float2 temp_output_39_0_g61513 = temp_output_39_0_g61515;
			float temp_output_10_0_g61513 = lerpResult35_g61515;
			float temp_output_5_0_g61513 = temp_output_5_0_g61515;
			float temp_output_8_0_g61513 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61513 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61513 - 0.0 ) );
			float temp_output_42_0_g61515 = temp_output_42_0_g61523;
			float temp_output_11_0_g61513 = ( ( lerpResult35_g61515 * ( 1.0 / temp_output_42_0_g61515 ) ) + temp_output_11_0_g61515 );
			float lerpResult18_g61513 = lerp( ( temp_output_8_0_g61513 > temp_output_11_0_g61513 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61513 < temp_output_11_0_g61513 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61513 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61513 = lerp( temp_output_10_0_g61513 , ( -0.5 * temp_output_10_0_g61513 ) , lerpResult18_g61513);
			float2 temp_output_6_0_g61506 = ( temp_output_6_0_g61513 - ( temp_output_39_0_g61513 * lerpResult35_g61513 ) );
			float2 temp_output_39_0_g61506 = temp_output_39_0_g61513;
			float temp_output_10_0_g61506 = lerpResult35_g61513;
			float temp_output_5_0_g61506 = temp_output_5_0_g61513;
			float temp_output_8_0_g61506 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61506 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61506 - 0.0 ) );
			float temp_output_42_0_g61513 = temp_output_42_0_g61515;
			float temp_output_11_0_g61506 = ( ( lerpResult35_g61513 * ( 1.0 / temp_output_42_0_g61513 ) ) + temp_output_11_0_g61513 );
			float lerpResult18_g61506 = lerp( ( temp_output_8_0_g61506 > temp_output_11_0_g61506 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61506 < temp_output_11_0_g61506 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61506 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61506 = lerp( temp_output_10_0_g61506 , ( -0.5 * temp_output_10_0_g61506 ) , lerpResult18_g61506);
			float2 temp_output_6_0_g61507 = ( temp_output_6_0_g61506 - ( temp_output_39_0_g61506 * lerpResult35_g61506 ) );
			float2 temp_output_39_0_g61507 = temp_output_39_0_g61506;
			float temp_output_10_0_g61507 = lerpResult35_g61506;
			float temp_output_5_0_g61507 = temp_output_5_0_g61506;
			float temp_output_8_0_g61507 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61507 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61507 - 0.0 ) );
			float temp_output_42_0_g61506 = temp_output_42_0_g61513;
			float temp_output_11_0_g61507 = ( ( lerpResult35_g61506 * ( 1.0 / temp_output_42_0_g61506 ) ) + temp_output_11_0_g61506 );
			float lerpResult18_g61507 = lerp( ( temp_output_8_0_g61507 > temp_output_11_0_g61507 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61507 < temp_output_11_0_g61507 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61507 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61507 = lerp( temp_output_10_0_g61507 , ( -0.5 * temp_output_10_0_g61507 ) , lerpResult18_g61507);
			float2 temp_output_6_0_g61508 = ( temp_output_6_0_g61507 - ( temp_output_39_0_g61507 * lerpResult35_g61507 ) );
			float2 temp_output_39_0_g61508 = temp_output_39_0_g61507;
			float temp_output_10_0_g61508 = lerpResult35_g61507;
			float temp_output_5_0_g61508 = temp_output_5_0_g61507;
			float temp_output_8_0_g61508 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61508 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61508 - 0.0 ) );
			float temp_output_42_0_g61507 = temp_output_42_0_g61506;
			float temp_output_11_0_g61508 = ( ( lerpResult35_g61507 * ( 1.0 / temp_output_42_0_g61507 ) ) + temp_output_11_0_g61507 );
			float lerpResult18_g61508 = lerp( ( temp_output_8_0_g61508 > temp_output_11_0_g61508 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61508 < temp_output_11_0_g61508 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61508 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61508 = lerp( temp_output_10_0_g61508 , ( -0.5 * temp_output_10_0_g61508 ) , lerpResult18_g61508);
			float2 temp_output_6_0_g61509 = ( temp_output_6_0_g61508 - ( temp_output_39_0_g61508 * lerpResult35_g61508 ) );
			float2 temp_output_39_0_g61509 = temp_output_39_0_g61508;
			float temp_output_10_0_g61509 = lerpResult35_g61508;
			float temp_output_5_0_g61509 = temp_output_5_0_g61508;
			float temp_output_8_0_g61509 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61509 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61509 - 0.0 ) );
			float temp_output_42_0_g61508 = temp_output_42_0_g61507;
			float temp_output_11_0_g61509 = ( ( lerpResult35_g61508 * ( 1.0 / temp_output_42_0_g61508 ) ) + temp_output_11_0_g61508 );
			float lerpResult18_g61509 = lerp( ( temp_output_8_0_g61509 > temp_output_11_0_g61509 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61509 < temp_output_11_0_g61509 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61509 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61509 = lerp( temp_output_10_0_g61509 , ( -0.5 * temp_output_10_0_g61509 ) , lerpResult18_g61509);
			float2 temp_output_6_0_g61511 = ( temp_output_6_0_g61509 - ( temp_output_39_0_g61509 * lerpResult35_g61509 ) );
			float2 temp_output_39_0_g61511 = temp_output_39_0_g61509;
			float temp_output_10_0_g61511 = lerpResult35_g61509;
			float temp_output_5_0_g61511 = temp_output_5_0_g61509;
			float temp_output_8_0_g61511 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61511 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61511 - 0.0 ) );
			float temp_output_42_0_g61509 = temp_output_42_0_g61508;
			float temp_output_11_0_g61511 = ( ( lerpResult35_g61509 * ( 1.0 / temp_output_42_0_g61509 ) ) + temp_output_11_0_g61509 );
			float lerpResult18_g61511 = lerp( ( temp_output_8_0_g61511 > temp_output_11_0_g61511 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61511 < temp_output_11_0_g61511 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61511 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61511 = lerp( temp_output_10_0_g61511 , ( -0.5 * temp_output_10_0_g61511 ) , lerpResult18_g61511);
			float2 temp_output_6_0_g61514 = ( temp_output_6_0_g61511 - ( temp_output_39_0_g61511 * lerpResult35_g61511 ) );
			float2 temp_output_39_0_g61514 = temp_output_39_0_g61511;
			float temp_output_10_0_g61514 = lerpResult35_g61511;
			float temp_output_5_0_g61514 = temp_output_5_0_g61511;
			float temp_output_8_0_g61514 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61514 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61514 - 0.0 ) );
			float temp_output_42_0_g61511 = temp_output_42_0_g61509;
			float temp_output_11_0_g61514 = ( ( lerpResult35_g61511 * ( 1.0 / temp_output_42_0_g61511 ) ) + temp_output_11_0_g61511 );
			float lerpResult18_g61514 = lerp( ( temp_output_8_0_g61514 > temp_output_11_0_g61514 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61514 < temp_output_11_0_g61514 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61514 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61514 = lerp( temp_output_10_0_g61514 , ( -0.5 * temp_output_10_0_g61514 ) , lerpResult18_g61514);
			float2 temp_output_6_0_g61510 = ( temp_output_6_0_g61514 - ( temp_output_39_0_g61514 * lerpResult35_g61514 ) );
			float2 temp_output_39_0_g61510 = temp_output_39_0_g61514;
			float temp_output_10_0_g61510 = lerpResult35_g61514;
			float temp_output_5_0_g61510 = temp_output_5_0_g61514;
			float temp_output_8_0_g61510 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61510 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61510 - 0.0 ) );
			float temp_output_42_0_g61514 = temp_output_42_0_g61511;
			float temp_output_11_0_g61510 = ( ( lerpResult35_g61514 * ( 1.0 / temp_output_42_0_g61514 ) ) + temp_output_11_0_g61514 );
			float lerpResult18_g61510 = lerp( ( temp_output_8_0_g61510 > temp_output_11_0_g61510 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61510 < temp_output_11_0_g61510 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61510 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61510 = lerp( temp_output_10_0_g61510 , ( -0.5 * temp_output_10_0_g61510 ) , lerpResult18_g61510);
			float2 temp_output_6_0_g61512 = ( temp_output_6_0_g61510 - ( temp_output_39_0_g61510 * lerpResult35_g61510 ) );
			float2 temp_output_39_0_g61512 = temp_output_39_0_g61510;
			float temp_output_10_0_g61512 = lerpResult35_g61510;
			float temp_output_5_0_g61512 = temp_output_5_0_g61510;
			float temp_output_8_0_g61512 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61512 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61512 - 0.0 ) );
			float temp_output_42_0_g61510 = temp_output_42_0_g61514;
			float temp_output_11_0_g61512 = ( ( lerpResult35_g61510 * ( 1.0 / temp_output_42_0_g61510 ) ) + temp_output_11_0_g61510 );
			float lerpResult18_g61512 = lerp( ( temp_output_8_0_g61512 > temp_output_11_0_g61512 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61512 < temp_output_11_0_g61512 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61512 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61512 = lerp( temp_output_10_0_g61512 , ( -0.5 * temp_output_10_0_g61512 ) , lerpResult18_g61512);
			float2 temp_output_6_0_g61537 = ( temp_output_6_0_g61512 - ( temp_output_39_0_g61512 * lerpResult35_g61512 ) );
			float2 temp_output_39_0_g61537 = temp_output_39_0_g61512;
			float temp_output_10_0_g61537 = lerpResult35_g61512;
			float temp_output_5_0_g61537 = temp_output_5_0_g61512;
			float temp_output_8_0_g61537 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61537 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61537 - 0.0 ) );
			float temp_output_42_0_g61512 = temp_output_42_0_g61510;
			float temp_output_11_0_g61537 = ( ( lerpResult35_g61512 * ( 1.0 / temp_output_42_0_g61512 ) ) + temp_output_11_0_g61512 );
			float lerpResult18_g61537 = lerp( ( temp_output_8_0_g61537 > temp_output_11_0_g61537 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61537 < temp_output_11_0_g61537 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61537 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61537 = lerp( temp_output_10_0_g61537 , ( -0.5 * temp_output_10_0_g61537 ) , lerpResult18_g61537);
			float2 temp_output_6_0_g61535 = ( temp_output_6_0_g61537 - ( temp_output_39_0_g61537 * lerpResult35_g61537 ) );
			float2 temp_output_39_0_g61535 = temp_output_39_0_g61537;
			float temp_output_10_0_g61535 = lerpResult35_g61537;
			float temp_output_5_0_g61535 = temp_output_5_0_g61537;
			float temp_output_8_0_g61535 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61535 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61535 - 0.0 ) );
			float temp_output_42_0_g61537 = temp_output_42_0_g61512;
			float temp_output_11_0_g61535 = ( ( lerpResult35_g61537 * ( 1.0 / temp_output_42_0_g61537 ) ) + temp_output_11_0_g61537 );
			float lerpResult18_g61535 = lerp( ( temp_output_8_0_g61535 > temp_output_11_0_g61535 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61535 < temp_output_11_0_g61535 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61535 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61535 = lerp( temp_output_10_0_g61535 , ( -0.5 * temp_output_10_0_g61535 ) , lerpResult18_g61535);
			float2 temp_output_6_0_g61528 = ( temp_output_6_0_g61535 - ( temp_output_39_0_g61535 * lerpResult35_g61535 ) );
			float2 temp_output_39_0_g61528 = temp_output_39_0_g61535;
			float temp_output_10_0_g61528 = lerpResult35_g61535;
			float temp_output_5_0_g61528 = temp_output_5_0_g61535;
			float temp_output_8_0_g61528 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61528 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61528 - 0.0 ) );
			float temp_output_42_0_g61535 = temp_output_42_0_g61537;
			float temp_output_11_0_g61528 = ( ( lerpResult35_g61535 * ( 1.0 / temp_output_42_0_g61535 ) ) + temp_output_11_0_g61535 );
			float lerpResult18_g61528 = lerp( ( temp_output_8_0_g61528 > temp_output_11_0_g61528 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61528 < temp_output_11_0_g61528 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61528 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61528 = lerp( temp_output_10_0_g61528 , ( -0.5 * temp_output_10_0_g61528 ) , lerpResult18_g61528);
			float2 temp_output_6_0_g61529 = ( temp_output_6_0_g61528 - ( temp_output_39_0_g61528 * lerpResult35_g61528 ) );
			float2 temp_output_39_0_g61529 = temp_output_39_0_g61528;
			float temp_output_10_0_g61529 = lerpResult35_g61528;
			float temp_output_5_0_g61529 = temp_output_5_0_g61528;
			float temp_output_8_0_g61529 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61529 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61529 - 0.0 ) );
			float temp_output_42_0_g61528 = temp_output_42_0_g61535;
			float temp_output_11_0_g61529 = ( ( lerpResult35_g61528 * ( 1.0 / temp_output_42_0_g61528 ) ) + temp_output_11_0_g61528 );
			float lerpResult18_g61529 = lerp( ( temp_output_8_0_g61529 > temp_output_11_0_g61529 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61529 < temp_output_11_0_g61529 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61529 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61529 = lerp( temp_output_10_0_g61529 , ( -0.5 * temp_output_10_0_g61529 ) , lerpResult18_g61529);
			float2 temp_output_6_0_g61530 = ( temp_output_6_0_g61529 - ( temp_output_39_0_g61529 * lerpResult35_g61529 ) );
			float2 temp_output_39_0_g61530 = temp_output_39_0_g61529;
			float temp_output_10_0_g61530 = lerpResult35_g61529;
			float temp_output_5_0_g61530 = temp_output_5_0_g61529;
			float temp_output_8_0_g61530 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61530 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61530 - 0.0 ) );
			float temp_output_42_0_g61529 = temp_output_42_0_g61528;
			float temp_output_11_0_g61530 = ( ( lerpResult35_g61529 * ( 1.0 / temp_output_42_0_g61529 ) ) + temp_output_11_0_g61529 );
			float lerpResult18_g61530 = lerp( ( temp_output_8_0_g61530 > temp_output_11_0_g61530 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61530 < temp_output_11_0_g61530 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61530 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61530 = lerp( temp_output_10_0_g61530 , ( -0.5 * temp_output_10_0_g61530 ) , lerpResult18_g61530);
			float2 temp_output_6_0_g61531 = ( temp_output_6_0_g61530 - ( temp_output_39_0_g61530 * lerpResult35_g61530 ) );
			float2 temp_output_39_0_g61531 = temp_output_39_0_g61530;
			float temp_output_10_0_g61531 = lerpResult35_g61530;
			float temp_output_5_0_g61531 = temp_output_5_0_g61530;
			float temp_output_8_0_g61531 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61531 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61531 - 0.0 ) );
			float temp_output_42_0_g61530 = temp_output_42_0_g61529;
			float temp_output_11_0_g61531 = ( ( lerpResult35_g61530 * ( 1.0 / temp_output_42_0_g61530 ) ) + temp_output_11_0_g61530 );
			float lerpResult18_g61531 = lerp( ( temp_output_8_0_g61531 > temp_output_11_0_g61531 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61531 < temp_output_11_0_g61531 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61531 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61531 = lerp( temp_output_10_0_g61531 , ( -0.5 * temp_output_10_0_g61531 ) , lerpResult18_g61531);
			float2 temp_output_6_0_g61533 = ( temp_output_6_0_g61531 - ( temp_output_39_0_g61531 * lerpResult35_g61531 ) );
			float2 temp_output_39_0_g61533 = temp_output_39_0_g61531;
			float temp_output_10_0_g61533 = lerpResult35_g61531;
			float temp_output_5_0_g61533 = temp_output_5_0_g61531;
			float temp_output_8_0_g61533 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61533 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61533 - 0.0 ) );
			float temp_output_42_0_g61531 = temp_output_42_0_g61530;
			float temp_output_11_0_g61533 = ( ( lerpResult35_g61531 * ( 1.0 / temp_output_42_0_g61531 ) ) + temp_output_11_0_g61531 );
			float lerpResult18_g61533 = lerp( ( temp_output_8_0_g61533 > temp_output_11_0_g61533 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61533 < temp_output_11_0_g61533 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61533 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61533 = lerp( temp_output_10_0_g61533 , ( -0.5 * temp_output_10_0_g61533 ) , lerpResult18_g61533);
			float2 temp_output_6_0_g61536 = ( temp_output_6_0_g61533 - ( temp_output_39_0_g61533 * lerpResult35_g61533 ) );
			float2 temp_output_39_0_g61536 = temp_output_39_0_g61533;
			float temp_output_10_0_g61536 = lerpResult35_g61533;
			float temp_output_5_0_g61536 = temp_output_5_0_g61533;
			float temp_output_8_0_g61536 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61536 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61536 - 0.0 ) );
			float temp_output_42_0_g61533 = temp_output_42_0_g61531;
			float temp_output_11_0_g61536 = ( ( lerpResult35_g61533 * ( 1.0 / temp_output_42_0_g61533 ) ) + temp_output_11_0_g61533 );
			float lerpResult18_g61536 = lerp( ( temp_output_8_0_g61536 > temp_output_11_0_g61536 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61536 < temp_output_11_0_g61536 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61536 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61536 = lerp( temp_output_10_0_g61536 , ( -0.5 * temp_output_10_0_g61536 ) , lerpResult18_g61536);
			float2 temp_output_6_0_g61532 = ( temp_output_6_0_g61536 - ( temp_output_39_0_g61536 * lerpResult35_g61536 ) );
			float2 temp_output_39_0_g61532 = temp_output_39_0_g61536;
			float temp_output_10_0_g61532 = lerpResult35_g61536;
			float temp_output_5_0_g61532 = temp_output_5_0_g61536;
			float temp_output_8_0_g61532 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61532 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61532 - 0.0 ) );
			float temp_output_42_0_g61536 = temp_output_42_0_g61533;
			float temp_output_11_0_g61532 = ( ( lerpResult35_g61536 * ( 1.0 / temp_output_42_0_g61536 ) ) + temp_output_11_0_g61536 );
			float lerpResult18_g61532 = lerp( ( temp_output_8_0_g61532 > temp_output_11_0_g61532 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61532 < temp_output_11_0_g61532 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61532 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61532 = lerp( temp_output_10_0_g61532 , ( -0.5 * temp_output_10_0_g61532 ) , lerpResult18_g61532);
			float2 temp_output_6_0_g61534 = ( temp_output_6_0_g61532 - ( temp_output_39_0_g61532 * lerpResult35_g61532 ) );
			float2 temp_output_39_0_g61534 = temp_output_39_0_g61532;
			float temp_output_10_0_g61534 = lerpResult35_g61532;
			float temp_output_5_0_g61534 = temp_output_5_0_g61532;
			float temp_output_8_0_g61534 =  (1.0 + ( SAMPLE_TEXTURE2D( _Disp, sampler_Disp, temp_output_6_0_g61534 ).r - 0.0 ) * ( 0.0 - 1.0 ) / ( temp_output_5_0_g61534 - 0.0 ) );
			float temp_output_42_0_g61532 = temp_output_42_0_g61536;
			float temp_output_11_0_g61534 = ( ( lerpResult35_g61532 * ( 1.0 / temp_output_42_0_g61532 ) ) + temp_output_11_0_g61532 );
			float lerpResult18_g61534 = lerp( ( temp_output_8_0_g61534 > temp_output_11_0_g61534 ? 1.0 : 0.0 ) , ( temp_output_8_0_g61534 < temp_output_11_0_g61534 ? 1.0 : 0.0 ) , saturate( ( sign( temp_output_10_0_g61534 ) > 0.0 ? 1.0 : 0.0 ) ));
			float lerpResult35_g61534 = lerp( temp_output_10_0_g61534 , ( -0.5 * temp_output_10_0_g61534 ) , lerpResult18_g61534);
			float2 POMTile78 = ( temp_output_6_0_g61534 - ( temp_output_39_0_g61534 * lerpResult35_g61534 ) );
			float3 dynamicSwitch35 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA )
			{
				dynamicSwitch35 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _ddna, sampler_ddna, POMTile78 ), _NormalStrength );
			}
			else
			{
				dynamicSwitch35 = _DDNAColor.rgb;
			}
			float3 break3_g61562 = dynamicSwitch35;
			float3 appendResult6_g61562 = (float3(( break3_g61562.y * 1.0 ) , ( break3_g61562.x * -1.0 ) , break3_g61562.z));
			float4 break4_g61549 = _DetailColor;
			float4 appendResult7_g61549 = (float4(break4_g61549.g , break4_g61549.a , break4_g61549.r , break4_g61549.b));
			float2 temp_output_1_0_g61549 = POMTile78;
			float3 tex2DNode5_g61549 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _Detail, sampler_Detail, temp_output_1_0_g61549 ), _NormalStrength );
			float4 tex2DNode6_g61549 = SAMPLE_TEXTURE2D( _Detail, sampler_Detail, temp_output_1_0_g61549 );
			float4 appendResult8_g61549 = (float4(tex2DNode5_g61549.r , tex2DNode5_g61549.g , tex2DNode6_g61549.b , tex2DNode6_g61549.a));
			float4 dynamicSwitch11 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL )
			{
				dynamicSwitch11 = appendResult8_g61549;
			}
			else
			{
				dynamicSwitch11 = appendResult7_g61549;
			}
			float4 break42_g61554 = dynamicSwitch11;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61554 = ( break42_g61554.y * -1.0 );
			#else
				float staticSwitch31_g61554 = break42_g61554.y;
			#endif
			float3 appendResult23_g61554 = (float3(break42_g61554.x , staticSwitch31_g61554 , 0.5));
			float3 lerpResult46_g61550 = lerp( appendResult6_g61562 , appendResult23_g61554 , float3( 0.5,0.5,0.5 ));
			float3 temp_output_111_0_g61559 = ddx( ase_positionWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_113_0_g61559 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61559 = dot( temp_output_111_0_g61559 , temp_output_113_0_g61559 );
			float4 dynamicSwitch38 = ( float4 )0;
			UNITY_BRANCH if ( _BLEND )
			{
				dynamicSwitch38 = SAMPLE_TEXTURE2D( _Blend, sampler_Blend, POMTile78 );
			}
			else
			{
				dynamicSwitch38 = _BlendColor;
			}
			float temp_output_6_0_g61553 = dynamicSwitch38.r;
			float temp_output_2_0_g61553 = ( ( temp_output_6_0_g61553 + ( _BlendFactor / 255.0 ) ) * ( _BlendFalloff / 255.0 ) );
			float blendFactor188_g61550 = saturate( temp_output_2_0_g61553 );
			float temp_output_20_0_g61559 = blendFactor188_g61550;
			float3 normalizeResult130_g61559 = normalize( ( ( abs( dotResult115_g61559 ) * ase_normalWS ) - ( 0.01 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61559 ) * ( ( ddx( temp_output_20_0_g61559 ) * temp_output_113_0_g61559 ) + ( ddy( temp_output_20_0_g61559 ) * cross( ase_normalWS , temp_output_111_0_g61559 ) ) ) ) ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_tangentWS, ase_bitangentWS, ase_normalWS );
			float3 worldToTangentDir42_g61559 = mul( ase_worldToTangent, normalizeResult130_g61559 );
			float3 temp_output_111_0_g61561 = ddx( ase_positionWS );
			float3 temp_output_113_0_g61561 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61561 = dot( temp_output_111_0_g61561 , temp_output_113_0_g61561 );
			float temp_output_29_0_g61550 = _POMDisplacement;
			float4 dynamicSwitch34 = ( float4 )0;
			UNITY_BRANCH if ( _DISP )
			{
				dynamicSwitch34 = SAMPLE_TEXTURE2D( _Disp, sampler_Disp, POMTile78 );
			}
			else
			{
				dynamicSwitch34 = _DispColor;
			}
			float4 temp_output_8_0_g61550 = dynamicSwitch34;
			float temp_output_28_0_g61550 = _HeightBias;
			float temp_output_20_0_g61561 = (  (0.0 + ( temp_output_8_0_g61550.r - 0.0 ) * ( 1.0 - 0.0 ) / ( temp_output_28_0_g61550 - 0.0 ) ) * blendFactor188_g61550 );
			float3 normalizeResult130_g61561 = normalize( ( ( abs( dotResult115_g61561 ) * ase_normalWS ) - ( temp_output_29_0_g61550 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61561 ) * ( ( ddx( temp_output_20_0_g61561 ) * temp_output_113_0_g61561 ) + ( ddy( temp_output_20_0_g61561 ) * cross( ase_normalWS , temp_output_111_0_g61561 ) ) ) ) ) );
			float3 worldToTangentDir42_g61561 = mul( ase_worldToTangent, normalizeResult130_g61561 );
			o.Normal = BlendNormals( BlendNormals( lerpResult46_g61550 , worldToTangentDir42_g61559 ) , worldToTangentDir42_g61561 );
			float4 dynamicSwitch32 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE )
			{
				dynamicSwitch32 = SAMPLE_TEXTURE2D( _Diffuse, sampler_Diffuse, POMTile78 );
			}
			else
			{
				dynamicSwitch32 = _DiffuseColor;
			}
			float4 break252_g61550 = dynamicSwitch32;
			float3 appendResult253_g61550 = (float3(break252_g61550.r , break252_g61550.g , break252_g61550.b));
			float4 blendOpSrc1_g61550 = _BaseColor;
			float4 blendOpDest1_g61550 = float4( appendResult253_g61550 , 0.0 );
			float4 baseDiffuseMix197_g61550 = saturate( ( saturate( ( blendOpSrc1_g61550 * blendOpDest1_g61550 ) )) );
			float clampResult8_g61552 = clamp( blendFactor188_g61550 , 0.0 , 1.0 );
			float4 lerpResult1_g61552 = lerp( baseDiffuseMix197_g61550 , _BlendLayer2DiffuseColor , clampResult8_g61552);
			float4 clampResult14_g61552 = clamp( lerpResult1_g61552 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 temp_output_9_0_g61556 = clampResult14_g61552;
			float temp_output_8_0_g61556 = break42_g61554.z;
			float3 temp_cast_5 = (temp_output_8_0_g61556).xxx;
			float3 temp_cast_6 = (temp_output_8_0_g61556).xxx;
			float3 linearToGamma14_g61556 = LinearToGammaSpace( temp_cast_6 );
			float4 blendOpSrc5_g61556 = float4( linearToGamma14_g61556 , 0.0 );
			float4 blendOpDest5_g61556 = temp_output_9_0_g61556;
			float temp_output_2_0_g61556 = _DetailDiffuseScale;
			float4 lerpResult6_g61556 = lerp( temp_output_9_0_g61556 , ( saturate( (( blendOpDest5_g61556 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61556 ) * ( 1.0 - blendOpSrc5_g61556 ) ) : ( 2.0 * blendOpDest5_g61556 * blendOpSrc5_g61556 ) ) )) , saturate( temp_output_2_0_g61556 ));
			float4 temp_output_9_0_g61555 = saturate( lerpResult6_g61556 );
			float4 dynamicSwitch31 = ( float4 )0;
			UNITY_BRANCH if ( _DECAL )
			{
				dynamicSwitch31 = SAMPLE_TEXTURE2D( _Decal, sampler_Decal, POMTile78 );
			}
			else
			{
				dynamicSwitch31 = _DecalColor;
			}
			float4 break255_g61550 = dynamicSwitch31;
			float3 appendResult254_g61550 = (float3(break255_g61550.r , break255_g61550.g , break255_g61550.b));
			float3 temp_output_8_0_g61555 = appendResult254_g61550;
			float4 blendOpSrc5_g61555 = float4( temp_output_8_0_g61555 , 0.0 );
			float4 blendOpDest5_g61555 = temp_output_9_0_g61555;
			float temp_output_2_0_g61555 = break255_g61550.a;
			float4 lerpResult6_g61555 = lerp( temp_output_9_0_g61555 , ( saturate( (( blendOpDest5_g61555 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61555 ) * ( 1.0 - blendOpSrc5_g61555 ) ) : ( 2.0 * blendOpDest5_g61555 * blendOpSrc5_g61555 ) ) )) , temp_output_2_0_g61555);
			float4 temp_output_314_0_g61550 = saturate( lerpResult6_g61555 );
			o.Albedo = temp_output_314_0_g61550.rgb;
			float diffuseAlpha193_g61550 = break252_g61550.a;
			float clampResult12_g61551 = clamp( ( i.vertexColor.g + i.vertexColor.g ) , 0.0 , 1.0 );
			o.Emission = ( ( baseDiffuseMix197_g61550 * diffuseAlpha193_g61550 ) * ( _Glow * diffuseAlpha193_g61550 * clampResult12_g61551 ) ).rgb;
			float4 dynamicSwitch33 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR )
			{
				dynamicSwitch33 = SAMPLE_TEXTURE2D( _Specular, sampler_Specular, POMTile78 );
			}
			else
			{
				dynamicSwitch33 = _SpecularColor;
			}
			float4 lerpResult9_g61552 = lerp( dynamicSwitch33 , _BlendLayer2SpecularColor , clampResult8_g61552);
			float4 clampResult15_g61552 = clamp( lerpResult9_g61552 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float3 linearToGamma321_g61550 = LinearToGammaSpace( clampResult15_g61552.rgb );
			o.Specular = linearToGamma321_g61550;
			float dynamicSwitch36 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP )
			{
				dynamicSwitch36 = SAMPLE_TEXTURE2D( _DDNAGlossmap, sampler_DDNAGlossmap, POMTile78 ).r;
			}
			else
			{
				dynamicSwitch36 = _DDNAColor.a;
			}
			float lerpResult10_g61552 = lerp( dynamicSwitch36 , ( _BlendLayer2Glossiness / 255.0 ) , clampResult8_g61552);
			float clampResult16_g61552 = clamp( lerpResult10_g61552 , 0.0 , 1.0 );
			float temp_output_9_0_g61557 = clampResult16_g61552;
			float3 temp_cast_13 = (temp_output_9_0_g61557).xxx;
			float3 temp_cast_14 = (temp_output_9_0_g61557).xxx;
			float3 linearToGamma15_g61557 = LinearToGammaSpace( temp_cast_14 );
			float temp_output_8_0_g61557 = break42_g61554.w;
			float3 temp_cast_15 = (temp_output_8_0_g61557).xxx;
			float3 temp_cast_16 = (temp_output_8_0_g61557).xxx;
			float3 linearToGamma14_g61557 = LinearToGammaSpace( temp_cast_16 );
			float3 temp_cast_17 = (temp_output_9_0_g61557).xxx;
			float3 blendOpSrc5_g61557 = linearToGamma14_g61557;
			float3 blendOpDest5_g61557 = linearToGamma15_g61557;
			float temp_output_2_0_g61557 = _DetailGlossScale;
			float3 lerpResult6_g61557 = lerp( linearToGamma15_g61557 , ( saturate( (( blendOpDest5_g61557 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61557 ) * ( 1.0 - blendOpSrc5_g61557 ) ) : ( 2.0 * blendOpDest5_g61557 * blendOpSrc5_g61557 ) ) )) , saturate( temp_output_2_0_g61557 ));
			float3 gammaToLinear16_g61557 = GammaToLinearSpace( saturate( lerpResult6_g61557 ) );
			float3 temp_output_313_0_g61550 = gammaToLinear16_g61557;
			o.Smoothness = temp_output_313_0_g61550.x;
			float lerpResult161_g61550 = lerp( 1.0 , diffuseAlpha193_g61550 , saturate( _UseAlpha ));
			o.Alpha = saturate( lerpResult161_g61550 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows nometa 

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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
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
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-528,640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-656,128;Inherit;False;Property;_NonPlanar;Non-Planar;14;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-704,576;Inherit;False;Property;_Bias;Bias;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-464,128;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-464,288;Inherit;False;Property;_Scale;Scale;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-384,576;Inherit;False;Property;_InvertBias;Invert Bias;13;0;Create;True;0;0;0;False;0;False;2;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-592,208;Inherit;False;Property;_Layers;Layers;11;0;Create;True;0;0;0;False;0;False;40;40;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-592,368;Inherit;True;Property;_Disp;Disp;5;0;Create;True;0;0;0;False;0;False;None;c4ca86660422cfe4d8947b7cb44acea9;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-160,288;Inherit;False;SC POM Vector;-1;;61504;b885b1e06f194f340908e3767f9051ad;0;6;4;FLOAT;1;False;9;FLOAT;40;False;10;FLOAT;1;False;26;SAMPLER2D;0;False;27;FLOAT;0.74;False;28;SAMPLERSTATE;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;128,288;Inherit;False;POMTile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;184.5466,-1535.693;Inherit;True;Property;_Detail;Detail;22;0;Create;True;0;0;0;False;0;False;None;43dbcf1df1cc7844cb4afb1430ad687d;True;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;104.5466,-1279.693;Inherit;False;Property;_NormalStrength;Normal Strength;34;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;376.5466,-1743.693;Inherit;False;Property;_DetailColor;Detail Color;21;0;Create;True;0;0;0;False;0;False;0.9411765,0.7333333,1,0.5019608;0.9411765,0.7333333,1,0.5019608;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;150.0009,-1111.736;Inherit;False;78;POMTile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;432,720;Inherit;False;78;POMTile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;150.001,-149.736;Inherit;False;78;POMTile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;81;336,-528;Inherit;False;78;POMTile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;728.5466,-1503.693;Inherit;False;SC Detail Switcher;-1;;61549;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;456.5466,-399.693;Inherit;False;Property;_SpecularColor;Specular Color;17;0;Create;True;0;0;0;False;0;False;0,0,0,1;0.03560132,0.03560132,0.03560132,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;440.5466,-207.693;Inherit;True;Property;_Specular;Specular;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;232.5466,-15.69301;Inherit;False;Property;_DispColor;Disp Color;19;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;600.5466,336.307;Inherit;True;Property;_Decal;Decal;24;0;Create;True;0;0;0;False;0;False;-1;None;38725d31faf27014883cd1eb0588d54e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;1080.547,-1503.693;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;680.5466,-1215.693;Inherit;True;Property;_Diffuse;Diffuse;8;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;38725d31faf27014883cd1eb0588d54e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;760.5466,-495.693;Inherit;True;Property;_DDNAGlossmap;DDNA Glossmap;15;0;Create;True;0;0;0;False;0;False;-1;None;eb1dea9f5180caa458037af2b5aa1c7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;504.5466,-719.693;Inherit;False;Property;_DDNAColor;DDNA Color;10;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,0.5019608;0.001960784,0.001960784,0.003921569,0.627451;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;712.5466,-1359.693;Inherit;False;Property;_DiffuseColor;Diffuse Color;6;1;[Gamma];Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0;0.5,0.5,0.5,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;360.5466,272.307;Inherit;False;Property;_DecalColor;Decal Color;23;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;712.5466,544.307;Inherit;True;Property;_Blend;Blend;26;0;Create;True;0;0;0;False;0;False;-1;None;c3a0eade880a30247a21225f92b336cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;408.5466,512.307;Inherit;False;Property;_BlendColor;Blend Color;25;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;760.5466,-767.693;Inherit;True;Property;_ddna;ddna;12;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;31b2e730dc5e31d4aa3b6a4b2e839e8d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;440.5466,48.30699;Inherit;True;Property;_DispSample;Disp Sample;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;728.5466,736.307;Inherit;False;Property;_BlendLayer2DiffuseColor;Blend Layer 2 Diffuse Color;27;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;21;744.5466,1008.307;Inherit;False;Property;_BlendFalloff;Blend Falloff;31;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;728.5466,928.307;Inherit;False;Property;_BlendFactor;Blend Factor;30;0;Create;True;0;0;0;False;0;False;0;2.40899;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;744.5466,1856.307;Inherit;False;Property;_DetailDiffuseScale;Detail Diffuse Scale;38;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;744.5466,1936.307;Inherit;False;Property;_DetailGlossScale;Detail Gloss Scale;39;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;776.5466,1456.307;Inherit;False;Property;_Glow;Glow;33;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;760.5466,1616.307;Inherit;False;Property;_UseAlpha;Use Alpha;35;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;728.5466,1776.307;Inherit;False;Property;_POMDisplacement;POM Displacement;37;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;744.5466,1296.307;Inherit;False;Property;_BlendLayer2Glossiness;Blend Layer 2 Glossiness;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;712.5466,1088.307;Inherit;False;Property;_BlendLayer2SpecularColor;Blend Layer 2 Specular Color;28;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.04518618,0.04518618,0.04518618,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;1288.547,-1503.693;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;1016.547,272.307;Inherit;False;Property;_DecalTexture;Decal Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DECAL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;952.5466,-1263.693;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;776.5466,-271.693;Inherit;False;Property;_SpecularTexture1;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;808.5466,-15.69301;Inherit;False;Property;_DispTexture;Disp Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DISP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;1160.547,-719.693;Inherit;False;Property;_DDNATexture;DDNA Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;1160.547,-559.693;Inherit;False;Property;_GlossmapTexture;Glossmap Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;728.5466,1696.307;Inherit;False;Property;_HeightBias;Height Bias;36;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;1080.547,512.307;Inherit;False;Property;_BlendTexture;Blend Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_BLEND;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;744.5466,-1023.693;Inherit;False;Property;_BaseColor;Base Color;1;1;[Gamma];Create;True;0;0;0;False;0;False;0.8,0.8,0.8,1;0.7960784,0.7294118,0.6823529,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;440.5466,-1535.693;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;1064.547,432.307;Inherit;False;Property;_Metalness;Metal Tweak;32;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;1528.547,1136.307;Inherit;False;Property;_Emission;_Emission;40;0;Create;True;0;0;0;True;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;1608.547,224.307;Inherit;True;SC Illum;2;;61550;b8f56813ea575f54dae41b63a9c1c583;1,234,0;26;257;COLOR;0,0,0,0;False;152;COLOR;0,0,0,0;False;142;COLOR;0,0,0,0;False;2;COLOR;0,0,0,1;False;18;FLOAT;0;False;5;FLOAT3;0,0,0;False;6;FLOAT;0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;13;COLOR;0,0,0,0;False;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;COLOR;0,0,0,0;False;20;COLOR;0,0,0,0;False;21;FLOAT;0;False;22;COLOR;0,0,0,0;False;23;FLOAT;0;False;24;FLOAT;0;False;25;FLOAT;0;False;27;FLOAT;0;False;28;FLOAT;0;False;29;FLOAT;0;False;30;FLOAT;0;False;31;FLOAT;0;False;32;FLOAT;0;False;7;COLOR;176;FLOAT3;178;FLOAT3;180;FLOAT;160;FLOAT3;164;COLOR;154;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;720,-144;Inherit;False;Property;_Brightness;Brightness;20;0;Create;True;0;0;0;False;0;False;-0.75;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;1120,-176;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;-0.75;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;71;1248,-176;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;992,-1360;Inherit;False;Property;_AlphaMidLevelControl;Alpha Mid-Level Control;16;0;Create;True;0;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;1264,-1360;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;1376,-1360;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;1552,-1360;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;67;1728,-1360;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;2176,224;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/Illum Parallax;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;True;True;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.01;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;45;0
WireConnection;46;0;44;0
WireConnection;48;1;45;0
WireConnection;48;0;43;0
WireConnection;52;4;46;0
WireConnection;52;9;49;0
WireConnection;52;10;47;0
WireConnection;52;26;50;0
WireConnection;52;27;48;0
WireConnection;52;28;50;1
WireConnection;78;0;52;0
WireConnection;5;1;82;0
WireConnection;5;2;1;0
WireConnection;5;3;4;0
WireConnection;5;9;2;0
WireConnection;7;1;80;0
WireConnection;10;1;79;0
WireConnection;11;1;5;0
WireConnection;11;0;5;10
WireConnection;12;1;82;0
WireConnection;13;1;81;0
WireConnection;17;1;79;0
WireConnection;19;1;81;0
WireConnection;19;5;2;0
WireConnection;9;0;50;0
WireConnection;9;1;80;0
WireConnection;9;7;50;1
WireConnection;30;0;11;0
WireConnection;31;1;16;0
WireConnection;31;0;10;0
WireConnection;32;1;15;0
WireConnection;32;0;12;0
WireConnection;33;1;6;0
WireConnection;33;0;7;0
WireConnection;34;1;8;0
WireConnection;34;0;9;0
WireConnection;35;1;14;5
WireConnection;35;0;19;0
WireConnection;36;1;14;4
WireConnection;36;0;13;1
WireConnection;38;1;18;0
WireConnection;38;0;17;0
WireConnection;3;2;1;0
WireConnection;42;257;30;0
WireConnection;42;152;31;0
WireConnection;42;142;32;0
WireConnection;42;2;39;0
WireConnection;42;5;35;0
WireConnection;42;6;36;0
WireConnection;42;7;33;0
WireConnection;42;8;34;0
WireConnection;42;13;38;0
WireConnection;42;14;20;0
WireConnection;42;15;22;0
WireConnection;42;16;21;0
WireConnection;42;20;29;0
WireConnection;42;21;28;0
WireConnection;42;25;25;0
WireConnection;42;27;26;0
WireConnection;42;28;37;0
WireConnection;42;29;27;0
WireConnection;42;30;23;0
WireConnection;42;31;24;0
WireConnection;64;0;33;0
WireConnection;64;1;60;0
WireConnection;71;0;64;0
WireConnection;53;0;51;0
WireConnection;53;1;32;0
WireConnection;59;0;53;0
WireConnection;66;1;59;0
WireConnection;67;0;66;0
WireConnection;0;0;42;154
WireConnection;0;1;42;164
WireConnection;0;2;42;0
WireConnection;0;3;42;180
WireConnection;0;4;42;178
WireConnection;0;9;42;160
ASEEND*/
//CHKSM=64CC84DEB55485765764B59DFA713A6E2F0BC2CB