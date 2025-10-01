// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Layer Blend"
{
	Properties
	{
		[Gamma] _BaseColor( "Base Color", Color ) = ( 1, 1, 1, 1 )
		_DDNAColor( "DDNA Color", Color ) = ( 0.5, 0.5, 1, 1 )
		_NormalStrength( "Normal Strength", Float ) = 0.5
		_DecalColor( "Decal Color", Color ) = ( 0, 0, 0, 1 )
		_WDAColor( "WDA Color", Color ) = ( 0, 0, 0, 1 )
		_WearLevel( "Wear Level", Float ) = 0
		_BlendColor( "Blend Color", Color ) = ( 1, 0, 0, 1 )
		_Transmission( "Transmission", Float ) = 0
		_Emission( "Emission", Color ) = ( 0, 0, 0, 0 )
		_Glow( "Glow", Float ) = 0
		_Tex13Color( "Tex 13 Color", Color ) = ( 1, 1, 1, 1 )
		_TexSlot13( "TexSlot13", 2D ) = "white" {}
		_PrimaryTintDiff( "Primary Tint Diff", Color ) = ( 0, 0, 0, 1 )
		_PrimaryTintSpec( "Primary Tint Spec", Color ) = ( 0.5, 0.5, 0.5, 1 )
		_PrimaryTintGloss( "Primary Tint Gloss", Float ) = 0.5
		[Gamma] _DiffuseColor1( "Diffuse Color 1", Color ) = ( 1, 0, 0, 1 )
		[Gamma] _Diffuse1( "Diffuse 1", 2D ) = "white" {}
		_DDNAColor1( "DDNA Color 1", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		[Normal] _ddna1( "ddna 1", 2D ) = "white" {}
		_DDNAGlossmap1( "DDNA Glossmap 1", 2D ) = "bump" {}
		_SpecularColor1( "Specular Color 1", Color ) = ( 0.2122307, 0.2122308, 0.2122308, 1 )
		_Specular1( "Specular 1", 2D ) = "white" {}
		_DetailColor1( "Detail Color 1", Color ) = ( 0, 0, 0, 1 )
		_Detail1( "Detail 1", 2D ) = "white" {}
		_UVScale1( "UV Scale 1", Vector ) = ( 1, 1, 0, 0 )
		_LayerTiling1( "Layer Tiling 1", Float ) = 1
		_DetailTiling1( "Detail Tiling 1", Float ) = 1
		_SecondaryTintDiff( "Secondary Tint Diff", Color ) = ( 0, 0, 0, 1 )
		_SecondaryTintSpec( "Secondary Tint Spec", Color ) = ( 0.5, 0.5, 0.5, 1 )
		_SecondaryTintGloss( "Secondary Tint Gloss", Float ) = 0.5
		[Gamma] _DiffuseColor2( "Diffuse Color 2", Color ) = ( 0.1, 0, 0, 1 )
		[Gamma] _Diffuse2( "Diffuse 2", 2D ) = "white" {}
		_DDNAColor2( "DDNA Color 2", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		[Normal] _ddna2( "ddna 2", 2D ) = "white" {}
		_DDNAGlossmap2( "DDNA Glossmap 2", 2D ) = "white" {}
		_SpecularColor2( "Specular Color 2", Color ) = ( 0.2117647, 0.2117647, 0.2117647, 1 )
		_Specular2( "Specular 2", 2D ) = "white" {}
		_DetailColor2( "Detail Color 2", Color ) = ( 0, 0, 0, 1 )
		_Detail2( "Detail 2", 2D ) = "white" {}
		_UVScale2( "UV Scale 2", Vector ) = ( 0, 0, 0, 0 )
		_LayerTiling2( "Layer Tiling 2", Float ) = 1
		_DetailTiling2( "Detail Tiling 2", Float ) = 1
		[Toggle( _FLIPGREENCHANNEL_ON )] _FlipGreenChannel( "Flip Green Channel", Float ) = 1
		_BaseLayer2Diff( "Base Layer 2 Diff", Color ) = ( 0, 1, 0, 1 )
		_BaseLayer2DDNA( "Base Layer 2 DDNA", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		_BaseLayer2Spec( "Base Layer 2 Spec", Color ) = ( 0.2117647, 0.2117647, 0.2117647 )
		_BaseLayer3Diff( "Base Layer 3 Diff", Color ) = ( 0, 0, 1, 1 )
		_BaseLayer3DDNA( "Base Layer 3 DDNA", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		_BaseLayer3Spec( "Base Layer 3 Spec", Color ) = ( 0.2117647, 0.2117647, 0.2117647 )
		_BaseLayer4Diff( "Base Layer 4 Diff", Color ) = ( 0, 0, 0, 1 )
		_BaseLayer4DDNA( "Base Layer 4 DDNA", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		_BaseLayer4Spec( "Base Layer 4 Spec", Color ) = ( 0.2117647, 0.2117647, 0.2117647 )
		_WearLayer2Diff( "Wear Layer 2 Diff", Color ) = ( 0, 0.1, 0, 1 )
		_WearLayer2DDNA( "Wear Layer 2 DDNA", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		_WearLayer2Spec( "Wear Layer 2 Spec", Color ) = ( 0.2117647, 0.2117647, 0.2117647 )
		_WearLayer3Diff( "Wear Layer 3 Diff", Color ) = ( 0, 0, 0.1, 1 )
		_WearLayer3DDNA( "Wear Layer 3 DDNA", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		_WearLayer3Spec( "Wear Layer 3 Spec", Color ) = ( 0.2117647, 0.2117647, 0.2117647 )
		_WearLayer4Diff( "Wear Layer 4 Diff", Color ) = ( 0, 0, 0, 1 )
		_WearLayer4DDNA( "Wear Layer 4 DDNA", Color ) = ( 0.5019608, 0.5019608, 1, 0.4509804 )
		_WearLayer4Spec( "Wear Layer 4 Spec", Color ) = ( 0.2117647, 0.2117647, 0.2117647 )
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] GenKey__Specular1( "Assign keyword _SPECULAR1", Float ) = 1.0
		[HideInInspector] GenKey__Specular2( "Assign keyword _SPECULAR2", Float ) = 1.0
		[HideInInspector] GenKey__ddna1( "Assign keyword _DDNA1", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse2( "Assign keyword _DIFFUSE2", Float ) = 1.0
		[HideInInspector] GenKey__Detail1( "Assign keyword _DETAIL1", Float ) = 1.0
		[HideInInspector] GenKey__ddna2( "Assign keyword _DDNA2", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap1( "Assign keyword _DDNAGLOSSMAP1", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse1( "Assign keyword _DIFFUSE1", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap2( "Assign keyword _DDNAGLOSSMAP2", Float ) = 1.0
		[HideInInspector] GenKey__Detail2( "Assign keyword _DETAIL2", Float ) = 1.0
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma dynamic_branch _DDNA1
		#pragma dynamic_branch _DETAIL1
		#pragma shader_feature_local _FLIPGREENCHANNEL_ON
		#pragma dynamic_branch _DDNAGLOSSMAP1
		#pragma dynamic_branch _DDNA2
		#pragma dynamic_branch _DETAIL2
		#pragma dynamic_branch _DDNAGLOSSMAP2
		#pragma dynamic_branch _TEXSLOT13
		#pragma dynamic_branch _DIFFUSE1
		#pragma dynamic_branch _DIFFUSE2
		#pragma dynamic_branch _SPECULAR1
		#pragma dynamic_branch _SPECULAR2
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
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputStandardSpecularCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half3 Specular;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Transmission;
		};

		uniform float4 _BaseLayer4DDNA;
		uniform float4 _BaseLayer3DDNA;
		uniform float4 _BlendColor;
		uniform float4 _BaseLayer2DDNA;
		uniform float4 _DDNAColor1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ddna1);
		uniform float2 _UVScale1;
		uniform float _LayerTiling1;
		SamplerState sampler_ddna1;
		uniform float _NormalStrength;
		uniform float4 _DetailColor1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail1);
		uniform float _DetailTiling1;
		SamplerState sampler_Detail1;
		uniform float _PrimaryTintGloss;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DDNAGlossmap1);
		SamplerState sampler_DDNAGlossmap1;
		uniform float4 _WearLayer4DDNA;
		uniform float4 _WearLayer3DDNA;
		uniform float4 _WearLayer2DDNA;
		uniform float4 _DDNAColor2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ddna2);
		uniform float2 _UVScale2;
		uniform float _LayerTiling2;
		SamplerState sampler_ddna2;
		uniform float4 _DetailColor2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail2);
		uniform float _DetailTiling2;
		SamplerState sampler_Detail2;
		uniform float _SecondaryTintGloss;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DDNAGlossmap2);
		SamplerState sampler_DDNAGlossmap2;
		uniform float _WearLevel;
		uniform float4 _WDAColor;
		uniform float4 _DDNAColor;
		uniform float4 _Tex13Color;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TexSlot13);
		uniform float4 _TexSlot13_ST;
		SamplerState sampler_TexSlot13;
		uniform float4 _BaseLayer4Diff;
		uniform float4 _BaseLayer3Diff;
		uniform float4 _BaseLayer2Diff;
		uniform float4 _PrimaryTintDiff;
		uniform float4 _DiffuseColor1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Diffuse1);
		SamplerState sampler_Diffuse1;
		uniform float4 _WearLayer4Diff;
		uniform float4 _WearLayer3Diff;
		uniform float4 _WearLayer2Diff;
		uniform float4 _SecondaryTintDiff;
		uniform float4 _DiffuseColor2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Diffuse2);
		SamplerState sampler_Diffuse2;
		uniform float4 _BaseColor;
		uniform float4 _DecalColor;
		uniform float4 _Emission;
		uniform float _Glow;
		uniform float3 _BaseLayer4Spec;
		uniform float3 _BaseLayer3Spec;
		uniform float3 _BaseLayer2Spec;
		uniform float4 _PrimaryTintSpec;
		uniform float4 _SpecularColor1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Specular1);
		SamplerState sampler_Specular1;
		uniform float3 _WearLayer4Spec;
		uniform float3 _WearLayer3Spec;
		uniform float3 _WearLayer2Spec;
		uniform float4 _SecondaryTintSpec;
		uniform float4 _SpecularColor2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Specular2);
		SamplerState sampler_Specular2;
		uniform float _Transmission;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingStandardSpecularCustom( SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + d;
		}

		inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardSpecularCustom o )
		{
			float4 temp_output_17_0_g61346 = _BlendColor;
			float4 temp_output_13_0_g61347 = temp_output_17_0_g61346;
			float4 break6_g61349 = temp_output_13_0_g61347;
			float3 lerpResult7_g61349 = lerp( _BaseLayer4DDNA.rgb , _BaseLayer3DDNA.rgb , break6_g61349.b);
			float3 lerpResult8_g61349 = lerp( lerpResult7_g61349 , _BaseLayer2DDNA.rgb , break6_g61349.g);
			float temp_output_2_0_g61268 = _LayerTiling1;
			float2 appendResult6_g61268 = (float2(temp_output_2_0_g61268 , temp_output_2_0_g61268));
			float2 temp_output_10_0_g61268 = ( _UVScale1 * appendResult6_g61268 );
			float2 uv_TexCoord3_g61268 = i.uv_texcoord * temp_output_10_0_g61268;
			float2 temp_output_10_0 = uv_TexCoord3_g61268;
			float n_Strength8 = ( _NormalStrength * 10.0 );
			float3 dynamicSwitch48 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA1 )
			{
				dynamicSwitch48 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _ddna1, sampler_ddna1, temp_output_10_0 ), n_Strength8 );
			}
			else
			{
				dynamicSwitch48 = _DDNAColor1.rgb;
			}
			float4 break4_g61273 = _DetailColor1;
			float4 appendResult7_g61273 = (float4(break4_g61273.g , break4_g61273.a , break4_g61273.r , break4_g61273.b));
			float temp_output_2_0_g61267 = _DetailTiling1;
			float2 appendResult6_g61267 = (float2(temp_output_2_0_g61267 , temp_output_2_0_g61267));
			float2 temp_output_10_0_g61267 = ( _UVScale1 * appendResult6_g61267 );
			float2 uv_TexCoord3_g61267 = i.uv_texcoord * temp_output_10_0_g61267;
			float2 temp_output_1_0_g61273 = uv_TexCoord3_g61267;
			float3 tex2DNode5_g61273 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _Detail1, sampler_Detail1, temp_output_1_0_g61273 ), n_Strength8 );
			float4 tex2DNode6_g61273 = SAMPLE_TEXTURE2D( _Detail1, sampler_Detail1, temp_output_1_0_g61273 );
			float4 appendResult8_g61273 = (float4(tex2DNode5_g61273.r , tex2DNode5_g61273.g , tex2DNode6_g61273.b , tex2DNode6_g61273.a));
			float4 dynamicSwitch46 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL1 )
			{
				dynamicSwitch46 = appendResult8_g61273;
			}
			else
			{
				dynamicSwitch46 = appendResult7_g61273;
			}
			float4 break42_g61341 = dynamicSwitch46;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61341 = ( break42_g61341.y * -1.0 );
			#else
				float staticSwitch31_g61341 = break42_g61341.y;
			#endif
			float3 appendResult23_g61341 = (float3(break42_g61341.x , staticSwitch31_g61341 , 0.5));
			float3 lerpResult35_g61340 = lerp( dynamicSwitch48 , appendResult23_g61341 , float3( 0.5,0.5,0.5 ));
			float temp_output_9_0_g61345 = break42_g61341.w;
			float3 temp_cast_2 = (temp_output_9_0_g61345).xxx;
			float3 temp_cast_3 = (temp_output_9_0_g61345).xxx;
			float3 linearToGamma15_g61345 = LinearToGammaSpace( temp_cast_3 );
			float dynamicSwitch47 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP1 )
			{
				dynamicSwitch47 = SAMPLE_TEXTURE2D( _DDNAGlossmap1, sampler_DDNAGlossmap1, temp_output_10_0 ).r;
			}
			else
			{
				dynamicSwitch47 = _DDNAColor1.a;
			}
			float blendOpSrc38_g61340 = _PrimaryTintGloss;
			float blendOpDest38_g61340 = dynamicSwitch47;
			float temp_output_8_0_g61345 = ( saturate( ( blendOpSrc38_g61340 * blendOpDest38_g61340 ) ));
			float3 temp_cast_4 = (temp_output_8_0_g61345).xxx;
			float3 temp_cast_5 = (temp_output_8_0_g61345).xxx;
			float3 linearToGamma14_g61345 = LinearToGammaSpace( temp_cast_5 );
			float3 temp_cast_6 = (temp_output_9_0_g61345).xxx;
			float3 blendOpSrc5_g61345 = linearToGamma14_g61345;
			float3 blendOpDest5_g61345 = linearToGamma15_g61345;
			float temp_output_2_0_g61345 = 0.0;
			float3 lerpResult6_g61345 = lerp( linearToGamma15_g61345 , ( saturate( (( blendOpDest5_g61345 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61345 ) * ( 1.0 - blendOpSrc5_g61345 ) ) : ( 2.0 * blendOpDest5_g61345 * blendOpSrc5_g61345 ) ) )) , saturate( temp_output_2_0_g61345 ));
			float3 gammaToLinear16_g61345 = GammaToLinearSpace( saturate( lerpResult6_g61345 ) );
			float4 appendResult37_g61340 = (float4(saturate( lerpResult35_g61340 ) , gammaToLinear16_g61345.x));
			float3 lerpResult9_g61349 = lerp( lerpResult8_g61349 , appendResult37_g61340.xyz , break6_g61349.r);
			float4 temp_output_13_0_g61361 = temp_output_17_0_g61346;
			float4 break6_g61363 = temp_output_13_0_g61361;
			float3 lerpResult7_g61363 = lerp( _WearLayer4DDNA.rgb , _WearLayer3DDNA.rgb , break6_g61363.b);
			float3 lerpResult8_g61363 = lerp( lerpResult7_g61363 , _WearLayer2DDNA.rgb , break6_g61363.g);
			float temp_output_2_0_g61270 = _LayerTiling2;
			float2 appendResult6_g61270 = (float2(temp_output_2_0_g61270 , temp_output_2_0_g61270));
			float2 temp_output_10_0_g61270 = ( _UVScale2 * appendResult6_g61270 );
			float2 uv_TexCoord3_g61270 = i.uv_texcoord * temp_output_10_0_g61270;
			float2 temp_output_15_0 = uv_TexCoord3_g61270;
			float3 dynamicSwitch52 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA2 )
			{
				dynamicSwitch52 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _ddna2, sampler_ddna2, temp_output_15_0 ), n_Strength8 );
			}
			else
			{
				dynamicSwitch52 = _DDNAColor2.rgb;
			}
			float4 break4_g61274 = _DetailColor2;
			float4 appendResult7_g61274 = (float4(break4_g61274.g , break4_g61274.a , break4_g61274.r , break4_g61274.b));
			float temp_output_2_0_g61269 = _DetailTiling2;
			float2 appendResult6_g61269 = (float2(temp_output_2_0_g61269 , temp_output_2_0_g61269));
			float2 temp_output_10_0_g61269 = ( _UVScale2 * appendResult6_g61269 );
			float2 uv_TexCoord3_g61269 = i.uv_texcoord * temp_output_10_0_g61269;
			float2 temp_output_1_0_g61274 = uv_TexCoord3_g61269;
			float3 tex2DNode5_g61274 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _Detail2, sampler_Detail2, temp_output_1_0_g61274 ), n_Strength8 );
			float4 tex2DNode6_g61274 = SAMPLE_TEXTURE2D( _Detail2, sampler_Detail2, temp_output_1_0_g61274 );
			float4 appendResult8_g61274 = (float4(tex2DNode5_g61274.r , tex2DNode5_g61274.g , tex2DNode6_g61274.b , tex2DNode6_g61274.a));
			float4 dynamicSwitch54 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL2 )
			{
				dynamicSwitch54 = appendResult8_g61274;
			}
			else
			{
				dynamicSwitch54 = appendResult7_g61274;
			}
			float4 break42_g61335 = dynamicSwitch54;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61335 = ( break42_g61335.y * -1.0 );
			#else
				float staticSwitch31_g61335 = break42_g61335.y;
			#endif
			float3 appendResult23_g61335 = (float3(break42_g61335.x , staticSwitch31_g61335 , 0.5));
			float3 lerpResult35_g61334 = lerp( dynamicSwitch52 , appendResult23_g61335 , float3( 0.5,0.5,0.5 ));
			float temp_output_9_0_g61339 = break42_g61335.w;
			float3 temp_cast_11 = (temp_output_9_0_g61339).xxx;
			float3 temp_cast_12 = (temp_output_9_0_g61339).xxx;
			float3 linearToGamma15_g61339 = LinearToGammaSpace( temp_cast_12 );
			float dynamicSwitch53 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP2 )
			{
				dynamicSwitch53 = SAMPLE_TEXTURE2D( _DDNAGlossmap2, sampler_DDNAGlossmap2, temp_output_15_0 ).r;
			}
			else
			{
				dynamicSwitch53 = _DDNAColor2.a;
			}
			float blendOpSrc38_g61334 = _SecondaryTintGloss;
			float blendOpDest38_g61334 = dynamicSwitch53;
			float temp_output_8_0_g61339 = ( saturate( ( blendOpSrc38_g61334 * blendOpDest38_g61334 ) ));
			float3 temp_cast_13 = (temp_output_8_0_g61339).xxx;
			float3 temp_cast_14 = (temp_output_8_0_g61339).xxx;
			float3 linearToGamma14_g61339 = LinearToGammaSpace( temp_cast_14 );
			float3 temp_cast_15 = (temp_output_9_0_g61339).xxx;
			float3 blendOpSrc5_g61339 = linearToGamma14_g61339;
			float3 blendOpDest5_g61339 = linearToGamma15_g61339;
			float temp_output_2_0_g61339 = 0.0;
			float3 lerpResult6_g61339 = lerp( linearToGamma15_g61339 , ( saturate( (( blendOpDest5_g61339 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61339 ) * ( 1.0 - blendOpSrc5_g61339 ) ) : ( 2.0 * blendOpDest5_g61339 * blendOpSrc5_g61339 ) ) )) , saturate( temp_output_2_0_g61339 ));
			float3 gammaToLinear16_g61339 = GammaToLinearSpace( saturate( lerpResult6_g61339 ) );
			float4 appendResult37_g61334 = (float4(saturate( lerpResult35_g61334 ) , gammaToLinear16_g61339.x));
			float3 lerpResult9_g61363 = lerp( lerpResult8_g61363 , appendResult37_g61334.xyz , break6_g61363.r);
			float Factor16_g61360 = ( ( _WearLevel + 0.0 ) * _WDAColor.b );
			float3 lerpResult32_g61360 = lerp( lerpResult9_g61349 , lerpResult9_g61363 , Factor16_g61360);
			float3 break3_g61356 = lerpResult32_g61360;
			float3 appendResult6_g61356 = (float3(( break3_g61356.y * 1.0 ) , ( break3_g61356.x * -1.0 ) , break3_g61356.z));
			float3 break3_g61357 = _DDNAColor.rgb;
			float3 appendResult6_g61357 = (float3(( break3_g61357.y * 1.0 ) , ( break3_g61357.x * -1.0 ) , break3_g61357.z));
			float3 lerpResult85_g61346 = lerp( appendResult6_g61356 , appendResult6_g61357 , float3( 0.5,0.5,0.5 ));
			float3 ase_positionWS = i.worldPos;
			float3 temp_output_111_0_g61359 = ddx( ase_positionWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_113_0_g61359 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61359 = dot( temp_output_111_0_g61359 , temp_output_113_0_g61359 );
			float3 break2_g61358 = temp_output_17_0_g61346.rgb;
			float temp_output_20_0_g61359 = ( ( ( break2_g61358.x * 0.3333333 ) + ( break2_g61358.y * 0.6666667 ) ) + ( break2_g61358.z * 1.0 ) );
			float3 normalizeResult130_g61359 = normalize( ( ( abs( dotResult115_g61359 ) * ase_normalWS ) - ( 0.1 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61359 ) * ( ( ddx( temp_output_20_0_g61359 ) * temp_output_113_0_g61359 ) + ( ddy( temp_output_20_0_g61359 ) * cross( ase_normalWS , temp_output_111_0_g61359 ) ) ) ) ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_tangentWS, ase_bitangentWS, ase_normalWS );
			float3 worldToTangentDir42_g61359 = mul( ase_worldToTangent, normalizeResult130_g61359 );
			o.Normal = BlendNormals( lerpResult85_g61346 , worldToTangentDir42_g61359 );
			float2 uv_TexSlot13 = i.uv_texcoord * _TexSlot13_ST.xy + _TexSlot13_ST.zw;
			float4 dynamicSwitch102 = ( float4 )0;
			UNITY_BRANCH if ( _TEXSLOT13 )
			{
				dynamicSwitch102 = SAMPLE_TEXTURE2D( _TexSlot13, sampler_TexSlot13, uv_TexSlot13 );
			}
			else
			{
				dynamicSwitch102 = _Tex13Color;
			}
			float4 break3_g61354 = dynamicSwitch102;
			float3 temp_cast_20 = (break3_g61354.g).xxx;
			float4 break6_g61348 = temp_output_13_0_g61347;
			float3 lerpResult7_g61348 = lerp( _BaseLayer4Diff.rgb , _BaseLayer3Diff.rgb , break6_g61348.b);
			float3 lerpResult8_g61348 = lerp( lerpResult7_g61348 , _BaseLayer2Diff.rgb , break6_g61348.g);
			float3 hsvTorgb6_g61343 = RGBToHSV( _PrimaryTintDiff.rgb );
			float lerpResult8_g61343 = lerp( hsvTorgb6_g61343.z , 0.003 , ( hsvTorgb6_g61343.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61343 = HSVToRGB( float3(hsvTorgb6_g61343.x,hsvTorgb6_g61343.y,lerpResult8_g61343) );
			float4 dynamicSwitch50 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE1 )
			{
				dynamicSwitch50 = SAMPLE_TEXTURE2D( _Diffuse1, sampler_Diffuse1, temp_output_10_0 );
			}
			else
			{
				dynamicSwitch50 = _DiffuseColor1;
			}
			float4 break26_g61340 = dynamicSwitch50;
			float3 appendResult27_g61340 = (float3(break26_g61340.r , break26_g61340.g , break26_g61340.b));
			float3 blendOpSrc23_g61340 = hsvTorgb9_g61343;
			float3 blendOpDest23_g61340 = appendResult27_g61340;
			float3 temp_output_9_0_g61344 = saturate( ( saturate( ( blendOpSrc23_g61340 * blendOpDest23_g61340 ) )) );
			float4 color45_g61340 = IsGammaSpace() ? float4( 0.5, 0.5, 0.5, 0.5019608 ) : float4( 0.2140411, 0.2140411, 0.2140411, 0.5019608 );
			float3 temp_output_8_0_g61344 = color45_g61340.rgb;
			float3 linearToGamma14_g61344 = LinearToGammaSpace( temp_output_8_0_g61344 );
			float3 blendOpSrc5_g61344 = linearToGamma14_g61344;
			float3 blendOpDest5_g61344 = temp_output_9_0_g61344;
			float temp_output_2_0_g61344 = 0.0;
			float3 lerpResult6_g61344 = lerp( temp_output_9_0_g61344 , ( saturate( (( blendOpDest5_g61344 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61344 ) * ( 1.0 - blendOpSrc5_g61344 ) ) : ( 2.0 * blendOpDest5_g61344 * blendOpSrc5_g61344 ) ) )) , saturate( temp_output_2_0_g61344 ));
			float3 break29_g61340 = saturate( lerpResult6_g61344 );
			float4 appendResult28_g61340 = (float4(break29_g61340.x , break29_g61340.y , break29_g61340.z , break26_g61340.a));
			float3 lerpResult9_g61348 = lerp( lerpResult8_g61348 , appendResult28_g61340.rgb , break6_g61348.r);
			float4 break6_g61362 = temp_output_13_0_g61361;
			float3 lerpResult7_g61362 = lerp( _WearLayer4Diff.rgb , _WearLayer3Diff.rgb , break6_g61362.b);
			float3 lerpResult8_g61362 = lerp( lerpResult7_g61362 , _WearLayer2Diff.rgb , break6_g61362.g);
			float3 hsvTorgb6_g61337 = RGBToHSV( _SecondaryTintDiff.rgb );
			float lerpResult8_g61337 = lerp( hsvTorgb6_g61337.z , 0.003 , ( hsvTorgb6_g61337.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61337 = HSVToRGB( float3(hsvTorgb6_g61337.x,hsvTorgb6_g61337.y,lerpResult8_g61337) );
			float4 dynamicSwitch45 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE2 )
			{
				dynamicSwitch45 = SAMPLE_TEXTURE2D( _Diffuse2, sampler_Diffuse2, temp_output_15_0 );
			}
			else
			{
				dynamicSwitch45 = _DiffuseColor2;
			}
			float4 break26_g61334 = dynamicSwitch45;
			float3 appendResult27_g61334 = (float3(break26_g61334.r , break26_g61334.g , break26_g61334.b));
			float3 blendOpSrc23_g61334 = hsvTorgb9_g61337;
			float3 blendOpDest23_g61334 = appendResult27_g61334;
			float3 temp_output_9_0_g61338 = saturate( ( saturate( ( blendOpSrc23_g61334 * blendOpDest23_g61334 ) )) );
			float4 color45_g61334 = IsGammaSpace() ? float4( 0.5, 0.5, 0.5, 0.5019608 ) : float4( 0.2140411, 0.2140411, 0.2140411, 0.5019608 );
			float3 temp_output_8_0_g61338 = color45_g61334.rgb;
			float3 linearToGamma14_g61338 = LinearToGammaSpace( temp_output_8_0_g61338 );
			float3 blendOpSrc5_g61338 = linearToGamma14_g61338;
			float3 blendOpDest5_g61338 = temp_output_9_0_g61338;
			float temp_output_2_0_g61338 = 0.0;
			float3 lerpResult6_g61338 = lerp( temp_output_9_0_g61338 , ( saturate( (( blendOpDest5_g61338 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61338 ) * ( 1.0 - blendOpSrc5_g61338 ) ) : ( 2.0 * blendOpDest5_g61338 * blendOpSrc5_g61338 ) ) )) , saturate( temp_output_2_0_g61338 ));
			float3 break29_g61334 = saturate( lerpResult6_g61338 );
			float4 appendResult28_g61334 = (float4(break29_g61334.x , break29_g61334.y , break29_g61334.z , break26_g61334.a));
			float3 lerpResult9_g61362 = lerp( lerpResult8_g61362 , appendResult28_g61334.rgb , break6_g61362.r);
			float3 lerpResult25_g61360 = lerp( lerpResult9_g61348 , lerpResult9_g61362 , Factor16_g61360);
			float4 blendOpSrc75_g61346 = float4( lerpResult25_g61360 , 0.0 );
			float4 blendOpDest75_g61346 = _BaseColor;
			float4 lerpResult76_g61346 = lerp( ( saturate( ( blendOpSrc75_g61346 * blendOpDest75_g61346 ) )) , _DecalColor , float4( 0,0,0,0 ));
			float3 hsvTorgb6_g61354 = RGBToHSV( lerpResult76_g61346.rgb );
			float temp_output_9_0_g61354 = ( hsvTorgb6_g61354.x + break3_g61354.b );
			float3 hsvTorgb12_g61354 = HSVToRGB( float3(( temp_output_9_0_g61354 > 1.0 ? ( temp_output_9_0_g61354 - 1.0 ) : temp_output_9_0_g61354 ),hsvTorgb6_g61354.y,hsvTorgb6_g61354.z) );
			float3 blendOpSrc13_g61354 = temp_cast_20;
			float3 blendOpDest13_g61354 = hsvTorgb12_g61354;
			float3 temp_output_13_0_g61354 = ( saturate( ( blendOpSrc13_g61354 * blendOpDest13_g61354 ) ));
			float3 lerpResult15_g61354 = lerp( temp_output_13_0_g61354 , ( temp_output_13_0_g61354 + ( 1.0 - break3_g61354.r ) ) , float3( 0.1,0,0 ));
			float3 temp_output_77_0_g61346 = lerpResult15_g61354;
			o.Albedo = temp_output_77_0_g61346;
			float4 lerpResult97_g61346 = lerp( float4( 0,0,0,0 ) , _Emission , temp_output_17_0_g61346.r);
			o.Emission = ( lerpResult97_g61346 * _Glow ).rgb;
			float4 break6_g61350 = temp_output_13_0_g61347;
			float3 lerpResult7_g61350 = lerp( _BaseLayer4Spec , _BaseLayer3Spec , break6_g61350.b);
			float3 lerpResult8_g61350 = lerp( lerpResult7_g61350 , _BaseLayer2Spec , break6_g61350.g);
			float4 dynamicSwitch49 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR1 )
			{
				dynamicSwitch49 = SAMPLE_TEXTURE2D( _Specular1, sampler_Specular1, temp_output_10_0 );
			}
			else
			{
				dynamicSwitch49 = _SpecularColor1;
			}
			float3 hsvTorgb6_g61342 = RGBToHSV( dynamicSwitch49.rgb );
			float lerpResult8_g61342 = lerp( hsvTorgb6_g61342.z , 0.003 , ( hsvTorgb6_g61342.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61342 = HSVToRGB( float3(hsvTorgb6_g61342.x,hsvTorgb6_g61342.y,lerpResult8_g61342) );
			float4 blendOpSrc31_g61340 = _PrimaryTintSpec;
			float4 blendOpDest31_g61340 = float4( pow( hsvTorgb9_g61342 , 1.0 ) , 0.0 );
			float3 lerpResult9_g61350 = lerp( lerpResult8_g61350 , saturate( ( saturate( ( blendOpSrc31_g61340 * blendOpDest31_g61340 ) )) ).rgb , break6_g61350.r);
			float3 temp_output_55_5_g61346 = lerpResult9_g61350;
			float4 break6_g61364 = temp_output_13_0_g61361;
			float3 lerpResult7_g61364 = lerp( _WearLayer4Spec , _WearLayer3Spec , break6_g61364.b);
			float3 lerpResult8_g61364 = lerp( lerpResult7_g61364 , _WearLayer2Spec , break6_g61364.g);
			float4 dynamicSwitch51 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR2 )
			{
				dynamicSwitch51 = SAMPLE_TEXTURE2D( _Specular2, sampler_Specular2, temp_output_15_0 );
			}
			else
			{
				dynamicSwitch51 = _SpecularColor2;
			}
			float3 hsvTorgb6_g61336 = RGBToHSV( dynamicSwitch51.rgb );
			float lerpResult8_g61336 = lerp( hsvTorgb6_g61336.z , 0.003 , ( hsvTorgb6_g61336.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61336 = HSVToRGB( float3(hsvTorgb6_g61336.x,hsvTorgb6_g61336.y,lerpResult8_g61336) );
			float4 blendOpSrc31_g61334 = _SecondaryTintSpec;
			float4 blendOpDest31_g61334 = float4( pow( hsvTorgb9_g61336 , 1.0 ) , 0.0 );
			float3 lerpResult9_g61364 = lerp( lerpResult8_g61364 , saturate( ( saturate( ( blendOpSrc31_g61334 * blendOpDest31_g61334 ) )) ).rgb , break6_g61364.r);
			float3 lerpResult33_g61360 = lerp( temp_output_55_5_g61346 , lerpResult9_g61364 , Factor16_g61360);
			float3 linearToGamma94_g61346 = LinearToGammaSpace( lerpResult33_g61360 );
			o.Specular = linearToGamma94_g61346;
			float4 break6_g61351 = temp_output_13_0_g61347;
			float lerpResult7_g61351 = lerp( _BaseLayer4DDNA.a , _BaseLayer3DDNA.a , break6_g61351.b);
			float lerpResult8_g61351 = lerp( lerpResult7_g61351 , _BaseLayer2DDNA.a , break6_g61351.g);
			float lerpResult9_g61351 = lerp( lerpResult8_g61351 , appendResult37_g61340.w , break6_g61351.r);
			float temp_output_20_0_g61360 = lerpResult9_g61351;
			float lerpResult36_g61360 = lerp( temp_output_20_0_g61360 , ( temp_output_20_0_g61360 * 0.5 ) , Factor16_g61360);
			o.Smoothness = lerpResult36_g61360;
			float3 temp_cast_34 = (_Transmission).xxx;
			o.Transmission = temp_cast_34;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecularCustom keepalpha fullforwardshadows exclude_path:deferred 

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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecularCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecularCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;352,-176;Inherit;False;Property;_NormalStrength;Normal Strength;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;576,-176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-2400,-32;Inherit;False;Property;_LayerTiling1;Layer Tiling 1;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-2384,96;Inherit;False;Property;_UVScale1;UV Scale 1;28;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-2416,240;Inherit;False;Property;_DetailTiling1;Detail Tiling 1;30;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-2880,1744;Inherit;False;Property;_LayerTiling2;Layer Tiling 2;44;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-2864,1856;Inherit;False;Property;_UVScale2;UV Scale 2;43;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-2896,2000;Inherit;False;Property;_DetailTiling2;Detail Tiling 2;45;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;736,-176;Inherit;False;n Strength;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-2192,128;Inherit;False;SC Texture Tiling;-1;;61267;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-2176,-128;Inherit;False;SC Texture Tiling;-1;;61268;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-1872,16;Inherit;False;Property;_DetailColor1;Detail Color 1;26;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-1872,224;Inherit;True;Property;_Detail1;Detail 1;27;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-2672,1904;Inherit;False;SC Texture Tiling;-1;;61269;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-2320,2192;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-2208,1520;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-2352,1792;Inherit;False;Property;_DetailColor2;Detail Color 2;41;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-2352,2000;Inherit;True;Property;_Detail2;Detail 2;42;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-2656,1648;Inherit;False;SC Texture Tiling;-1;;61270;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-1728,-256;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-1840,416;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-1504,-432;Inherit;True;Property;_Specular1;Specular 1;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-1520,-816;Inherit;True;Property;_Diffuse1;Diffuse 1;20;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-1520,256;Inherit;False;SC Detail Switcher;-1;;61273;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;21;-2000,2032;Inherit;False;SC Detail Switcher;-1;;61274;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-1984,1824;Inherit;True;Property;_DDNAGlossmap2;DDNA Glossmap 2;38;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;-2000,960;Inherit;True;Property;_Diffuse2;Diffuse 2;35;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-1532,48;Inherit;True;Property;_DDNAGlossmap1;DDNA Glossmap 1;23;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;-1984,1344;Inherit;True;Property;_Specular2;Specular 2;40;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-1984,1552;Inherit;True;Property;_ddna2;ddna 2;37;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-1504,-224;Inherit;True;Property;_ddna1;ddna 1;22;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;-1456,-896;Inherit;False;Property;_DiffuseColor1;Diffuse Color 1;19;1;[Gamma];Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-1488,-624;Inherit;False;Property;_SpecularColor1;Specular Color 1;24;0;Create;True;0;0;0;False;0;False;0.2122307,0.2122308,0.2122308,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-1968,1152;Inherit;False;Property;_SpecularColor2;Specular Color 2;39;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-1936,864;Inherit;False;Property;_DiffuseColor2;Diffuse Color 2;34;1;[Gamma];Create;True;0;0;0;False;0;False;0.1,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-1760,-176;Inherit;False;Property;_DDNAColor1;DDNA Color 1;21;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-2240,1600;Inherit;False;Property;_DDNAColor2;DDNA Color 2;36;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-1072,96;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-1104,-176;Inherit;False;Property;_DDNATexture1;DDNA Texture 1;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1104,-304;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-1104,-400;Inherit;False;Property;_SpecularTexture1;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1584,1472;Inherit;False;Property;_SpecularTexture2;Specular Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-1584,1600;Inherit;False;Property;_DDNATexture2;DDNA Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;-1584,1760;Inherit;False;Property;_GlossmapTexture2;Glossmap Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-1552,1872;Inherit;False;Property;_DetailTexture1;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-1648,992;Inherit;False;Property;_DiffuseTexture2;Diffuse Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-1104,-16;Inherit;False;Property;_GlossmapTexture1;Glossmap Texture1;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-832,-160;Inherit;True;Property;_TexSlot13;TexSlot13;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-768,-352;Inherit;False;Property;_Tex13Color;Tex 13 Color;14;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;-1104,-864;Inherit;False;Property;_PrimaryTintDiff;Primary Tint Diff;16;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1104,-672;Inherit;False;Property;_PrimaryTintSpec;Primary Tint Spec;17;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1104,-480;Inherit;False;Property;_PrimaryTintGloss;Primary Tint Gloss;18;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1536,752;Inherit;False;Property;_SecondaryTintDiff;Secondary Tint Diff;31;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-1504,800;Inherit;False;Property;_SecondaryTintSpec;Secondary Tint Spec;32;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-1504,848;Inherit;False;Property;_SecondaryTintGloss;Secondary Tint Gloss;33;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;76;-1168,1056;Inherit;False;SC Tint;46;;61334;80e1f18b9d7c52c4fa81e9ff33b30a1d;0;8;15;COLOR;0,0,0,0;False;16;COLOR;0,0,0,0;False;17;FLOAT;0;False;12;COLOR;0,0,0,0;False;18;COLOR;0,0,0,0;False;6;FLOAT3;0,0,0;False;14;FLOAT;0;False;19;COLOR;0,0,0,0;False;5;COLOR;0;FLOAT;48;FLOAT4;1;FLOAT;46;COLOR;2
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-528,-160;Inherit;False;Property;_Texture13;Texture 13;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_TEXSLOT13;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-512,-48;Inherit;False;Property;_Glow;Glow;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-832,-1088;Inherit;False;Property;_DecalColor;Decal Color;5;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;75;-592,64;Inherit;False;SC Tint;46;;61340;80e1f18b9d7c52c4fa81e9ff33b30a1d;0;8;15;COLOR;0,0,0,0;False;16;COLOR;0,0,0,0;False;17;FLOAT;0;False;12;COLOR;0,0,0,0;False;18;COLOR;0,0,0,0;False;6;FLOAT3;0,0,0;False;14;FLOAT;0;False;19;COLOR;0,0,0,0;False;5;COLOR;0;FLOAT;48;FLOAT4;1;FLOAT;46;COLOR;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-672,-640;Inherit;False;Property;_WearLevel;Wear Level;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-672,-496;Inherit;False;Property;_Emission;Emission;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;-704,-1216;Inherit;False;Property;_BaseColor;Base Color;0;1;[Gamma];Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;67;-576,-944;Inherit;False;Property;_DDNAColor;DDNA Color;2;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-704,-848;Inherit;False;Property;_WDAColor;WDA Color;6;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-848,-672;Inherit;False;Property;_BlendColor;Blend Color;8;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;-560,320;Inherit;False;Property;_BaseLayer2Spec;Base Layer 2 Spec;51;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-464,1296;Inherit;False;Property;_WearLayer2Spec;Wear Layer 2 Spec;60;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-464,1552;Inherit;False;Property;_WearLayer3Spec;Wear Layer 3 Spec;63;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-464,1856;Inherit;False;Property;_WearLayer4Spec;Wear Layer 4 Spec;66;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;77;-1072,208;Inherit;False;Property;_BaseLayer2Diff;Base Layer 2 Diff;49;0;Create;True;0;0;0;False;0;False;0,1,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-1072,496;Inherit;False;Property;_BaseLayer3Diff;Base Layer 3 Diff;52;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-1072,752;Inherit;False;Property;_BaseLayer4Diff;Base Layer 4 Diff;55;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;-848,1200;Inherit;False;Property;_WearLayer2Diff;Wear Layer 2 Diff;58;0;Create;True;0;0;0;False;0;False;0,0.1,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-848,1456;Inherit;False;Property;_WearLayer3Diff;Wear Layer 3 Diff;61;0;Create;True;0;0;0;False;0;False;0,0,0.1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-848,1744;Inherit;False;Property;_WearLayer4Diff;Wear Layer 4 Diff;64;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;-656,1248;Inherit;False;Property;_WearLayer2DDNA;Wear Layer 2 DDNA;59;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-656,1504;Inherit;False;Property;_WearLayer3DDNA;Wear Layer 3 DDNA;62;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-656,1792;Inherit;False;Property;_WearLayer4DDNA;Wear Layer 4 DDNA;65;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;81;-816,544;Inherit;False;Property;_BaseLayer3DDNA;Base Layer 3 DDNA;53;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;-816,256;Inherit;False;Property;_BaseLayer2DDNA;Base Layer 2 DDNA;50;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-816,784;Inherit;False;Property;_BaseLayer4DDNA;Base Layer 4 DDNA;56;0;Create;True;0;0;0;False;0;False;0.5019608,0.5019608,1,0.4509804;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-544,848;Inherit;False;Property;_BaseLayer4Spec;Base Layer 4 Spec;57;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-544,608;Inherit;False;Property;_BaseLayer3Spec;Base Layer 3 Spec;54;0;Create;True;0;0;0;False;0;False;0.2117647,0.2117647,0.2117647,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-656,-560;Inherit;False;Property;_MetalTweak;Metal Tweak;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;272,144;Inherit;False;Property;_Transmission;Transmission;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-336,-864;Inherit;False;Property;_SpecularColor;Specular Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-31.63806,-806.7836;Inherit;False;Property;_DispColor;Disp Color;9;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-96,-80;Inherit;False;SC Layer Blend;-1;;61346;58d12b21814b6fc48b12590f1cece3ab;0;63;62;COLOR;0,0,0,0;False;63;COLOR;0,0,0,0;False;64;COLOR;0,0,0,0;False;65;COLOR;0,0,0,0;False;66;COLOR;0,0,0,0;False;60;COLOR;0,0,0,0;False;61;FLOAT;0;False;17;COLOR;0,0,0,0;False;67;COLOR;0,0,0,0;False;68;FLOAT;0;False;100;FLOAT;0;False;101;FLOAT;0;False;70;COLOR;0,0,0,0;False;71;FLOAT;0;False;72;COLOR;0,0,0,0;False;18;FLOAT3;0,0,0;False;22;FLOAT;0;False;26;FLOAT3;0,0,0;False;9;FLOAT;0;False;5;FLOAT3;0,0,0;False;13;FLOAT;0;False;19;FLOAT3;0,0,0;False;23;FLOAT;0;False;27;FLOAT3;0,0,0;False;10;FLOAT;0;False;6;FLOAT3;0,0,0;False;14;FLOAT;0;False;20;FLOAT3;0,0,0;False;24;FLOAT;0;False;28;FLOAT3;0,0,0;False;11;FLOAT;0;False;7;FLOAT3;0,0,0;False;15;FLOAT;0;False;21;FLOAT3;0,0,0;False;25;FLOAT;0;False;29;FLOAT3;0,0,0;False;12;FLOAT;0;False;8;FLOAT3;0,0,0;False;16;FLOAT;0;False;43;FLOAT3;0,0,0;False;47;FLOAT;0;False;51;FLOAT3;0,0,0;False;34;FLOAT;0;False;30;FLOAT3;0,0,0;False;38;FLOAT;0;False;44;FLOAT3;0,0,0;False;48;FLOAT;0;False;52;FLOAT3;0,0,0;False;35;FLOAT;0;False;31;FLOAT3;0,0,0;False;39;FLOAT;0;False;45;FLOAT3;0,0,0;False;49;FLOAT;0;False;53;FLOAT3;0,0,0;False;36;FLOAT;0;False;32;FLOAT3;0,0,0;False;40;FLOAT;0;False;46;FLOAT3;0,0,0;False;50;FLOAT;0;False;54;FLOAT3;0,0,0;False;37;FLOAT;0;False;33;FLOAT3;0,0,0;False;41;FLOAT;0;False;5;FLOAT3;90;COLOR;99;FLOAT;92;FLOAT3;0;FLOAT3;80
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-1056,-1136;Inherit;False;Property;_DiffuseColor;Diffuse Color;1;1;[Gamma];Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;576,-80;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/Layer Blend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.02;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;95;0;1;0
WireConnection;8;0;95;0
WireConnection;9;9;3;0
WireConnection;9;2;4;0
WireConnection;10;9;3;0
WireConnection;10;2;2;0
WireConnection;13;9;6;0
WireConnection;13;2;7;0
WireConnection;15;9;6;0
WireConnection;15;2;5;0
WireConnection;30;1;10;0
WireConnection;34;1;10;0
WireConnection;35;1;9;0
WireConnection;35;2;20;0
WireConnection;35;3;18;0
WireConnection;35;9;12;0
WireConnection;21;1;13;0
WireConnection;21;2;19;0
WireConnection;21;3;17;0
WireConnection;21;9;14;0
WireConnection;33;1;15;0
WireConnection;28;1;15;0
WireConnection;36;1;10;0
WireConnection;31;1;15;0
WireConnection;32;1;15;0
WireConnection;32;5;16;0
WireConnection;29;1;10;0
WireConnection;29;5;11;0
WireConnection;46;1;35;0
WireConnection;46;0;35;10
WireConnection;48;1;24;5
WireConnection;48;0;29;0
WireConnection;49;1;22;0
WireConnection;49;0;30;0
WireConnection;50;1;23;0
WireConnection;50;0;34;0
WireConnection;51;1;26;0
WireConnection;51;0;31;0
WireConnection;52;1;27;5
WireConnection;52;0;32;0
WireConnection;53;1;27;4
WireConnection;53;0;33;1
WireConnection;54;1;21;0
WireConnection;54;0;21;10
WireConnection;45;1;25;0
WireConnection;45;0;28;0
WireConnection;47;1;24;4
WireConnection;47;0;36;1
WireConnection;76;15;41;0
WireConnection;76;16;42;0
WireConnection;76;17;43;0
WireConnection;76;12;45;0
WireConnection;76;18;51;0
WireConnection;76;6;52;0
WireConnection;76;14;53;0
WireConnection;76;19;54;0
WireConnection;102;1;103;0
WireConnection;102;0;101;0
WireConnection;75;15;38;0
WireConnection;75;16;39;0
WireConnection;75;17;40;0
WireConnection;75;12;50;0
WireConnection;75;18;49;0
WireConnection;75;6;48;0
WireConnection;75;14;47;0
WireConnection;75;19;46;0
WireConnection;110;62;98;0
WireConnection;110;64;67;0
WireConnection;110;66;59;0
WireConnection;110;60;100;0
WireConnection;110;61;64;0
WireConnection;110;17;107;0
WireConnection;110;70;63;0
WireConnection;110;71;105;0
WireConnection;110;72;102;0
WireConnection;110;18;75;0
WireConnection;110;22;75;48
WireConnection;110;26;75;1
WireConnection;110;9;75;46
WireConnection;110;5;75;2
WireConnection;110;19;77;5
WireConnection;110;23;77;4
WireConnection;110;27;78;5
WireConnection;110;10;78;4
WireConnection;110;6;79;0
WireConnection;110;20;80;5
WireConnection;110;24;80;4
WireConnection;110;28;81;5
WireConnection;110;11;81;4
WireConnection;110;7;82;0
WireConnection;110;21;83;5
WireConnection;110;25;83;4
WireConnection;110;29;84;5
WireConnection;110;12;84;4
WireConnection;110;8;85;0
WireConnection;110;43;76;0
WireConnection;110;47;76;48
WireConnection;110;51;76;1
WireConnection;110;34;76;46
WireConnection;110;30;76;2
WireConnection;110;44;86;5
WireConnection;110;48;86;4
WireConnection;110;52;87;5
WireConnection;110;35;87;4
WireConnection;110;31;88;0
WireConnection;110;45;89;5
WireConnection;110;49;89;4
WireConnection;110;53;90;5
WireConnection;110;36;90;4
WireConnection;110;32;91;0
WireConnection;110;46;92;5
WireConnection;110;50;92;4
WireConnection;110;54;93;5
WireConnection;110;37;93;4
WireConnection;110;33;94;0
WireConnection;0;0;110;0
WireConnection;0;1;110;90
WireConnection;0;2;110;99
WireConnection;0;3;110;80
WireConnection;0;4;110;92
WireConnection;0;6;106;0
ASEEND*/
//CHKSM=DB9BCDC25D3620D1C4C247B154AC69C04ACC29D3