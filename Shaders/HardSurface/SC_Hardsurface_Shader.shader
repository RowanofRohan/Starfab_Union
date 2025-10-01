// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/HardSurface"
{
	Properties
	{
		[Gamma] _DiffuseColor( "Diffuse Color", Color ) = ( 1, 1, 1, 0 )
		_DDNAColor( "DDNA Color", Color ) = ( 0.5, 0.5, 1, 1 )
		_SpecularColor( "Specular Color", Color ) = ( 0, 0, 0, 1 )
		_DecalColor( "Decal Color", Color ) = ( 0.9490196, 0.5568628, 0.2117647, 0 )
		_PrimaryTintDiff( "Primary Tint Diff", Color ) = ( 0, 0, 0, 1 )
		_PrimaryTintSpec( "Primary Tint Spec", Color ) = ( 1, 1, 1, 1 )
		_PrimaryTintGloss( "Primary Tint Gloss", Float ) = 0.5
		[Gamma] _DiffuseColor1( "Diffuse Color 1", Color ) = ( 0.5, 0.5, 0.5, 1 )
		[Gamma] _Diffuse1( "Diffuse 1", 2D ) = "white" {}
		_DDNAColor1( "DDNA Color 1", Color ) = ( 0.5, 0.5, 1, 1 )
		[Normal] _ddna1( "ddna 1", 2D ) = "white" {}
		_DDNAGlossmap1( "DDNA Glossmap 1", 2D ) = "bump" {}
		_SpecularColor1( "Specular Color 1", Color ) = ( 0, 0, 0, 1 )
		_Specular1( "Specular 1", 2D ) = "white" {}
		_DetailColor1( "Detail Color 1", Color ) = ( 0, 0, 0, 1 )
		_Detail1( "Detail 1", 2D ) = "white" {}
		_BlendColor1( "Blend Color 1", Float ) = 0
		_BlendTex1( "Blend Tex 1", 2D ) = "white" {}
		_UVScale1( "UV Scale 1", Vector ) = ( 0, 0, 0, 0 )
		_LayerTiling1( "Layer Tiling 1", Float ) = 1
		_DetailTiling1( "Detail Tiling 1", Float ) = 1
		_SecondaryTintDiff( "Secondary Tint Diff", Color ) = ( 0, 0, 0, 1 )
		_SecondaryTintSpec( "Secondary Tint Spec", Color ) = ( 1, 1, 1, 1 )
		_SecondaryTintGloss( "Secondary Tint Gloss", Float ) = 0.5
		[Gamma] _DiffuseColor2( "Diffuse Color 2", Color ) = ( 0.5, 0.5, 0.5, 1 )
		[Gamma] _Diffuse2( "Diffuse 2", 2D ) = "white" {}
		_DDNAColor2( "DDNA Color 2", Color ) = ( 0.5, 0.5, 1, 1 )
		[Normal] _ddna2( "ddna 2", 2D ) = "white" {}
		_DDNAGlossmap2( "DDNA Glossmap 2", 2D ) = "white" {}
		_SpecularColor2( "Specular Color 2", Color ) = ( 0, 0, 0, 1 )
		_Specular2( "Specular 2", 2D ) = "white" {}
		_DetailColor2( "Detail Color 2", Color ) = ( 0, 0, 0, 1 )
		_Detail2( "Detail 2", 2D ) = "white" {}
		_UVScale2( "UV Scale 2", Vector ) = ( 0, 0, 0, 0 )
		_LayerTiling2( "Layer Tiling 2", Float ) = 1
		_DetailTiling2( "Detail Tiling 2", Float ) = 1
		_WearLevel( "Wear Level", Float ) = 0
		_NormalStrength( "Normal Strength", Float ) = 1
		_Emission( "Emission", Color ) = ( 0, 0, 0, 0 )
		[Toggle( _FLIPGREENCHANNEL_ON )] _FlipGreenChannel( "Flip Green Channel", Float ) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] GenKey__ddna1( "Assign keyword _DDNA1", Float ) = 1.0
		[HideInInspector] GenKey__Detail1( "Assign keyword _DETAIL1", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap1( "Assign keyword _DDNAGLOSSMAP1", Float ) = 1.0
		[HideInInspector] GenKey__ddna2( "Assign keyword _DDNA2", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse1( "Assign keyword _DIFFUSE1", Float ) = 1.0
		[HideInInspector] GenKey__Specular1( "Assign keyword _SPECULAR1", Float ) = 1.0
		[HideInInspector] GenKey__Detail2( "Assign keyword _DETAIL2", Float ) = 1.0
		[HideInInspector] GenKey__Specular2( "Assign keyword _SPECULAR2", Float ) = 1.0
		[HideInInspector] GenKey__BlendTex1( "Assign keyword _BLENDTEX1", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse2( "Assign keyword _DIFFUSE2", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap2( "Assign keyword _DDNAGLOSSMAP2", Float ) = 1.0
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
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
		#pragma dynamic_branch _BLENDTEX1
		#pragma dynamic_branch _DIFFUSE1
		#pragma dynamic_branch _DIFFUSE2
		#pragma dynamic_branch _SPECULAR1
		#pragma dynamic_branch _SPECULAR2
		#define ASE_VERSION 19904
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _DDNAColor;
		uniform float4 _DDNAColor1;
		uniform sampler2D _ddna1;
		uniform float2 _UVScale1;
		uniform float _LayerTiling1;
		uniform float _NormalStrength;
		uniform float4 _DetailColor1;
		uniform sampler2D _Detail1;
		uniform float _DetailTiling1;
		uniform float _PrimaryTintGloss;
		uniform sampler2D _DDNAGlossmap1;
		uniform float4 _DDNAColor2;
		uniform sampler2D _ddna2;
		uniform float2 _UVScale2;
		uniform float _LayerTiling2;
		uniform float4 _DetailColor2;
		uniform sampler2D _Detail2;
		uniform float _DetailTiling2;
		uniform float _SecondaryTintGloss;
		uniform sampler2D _DDNAGlossmap2;
		uniform float _WearLevel;
		uniform float _BlendColor1;
		uniform sampler2D _BlendTex1;
		uniform float4 _DiffuseColor;
		uniform float4 _PrimaryTintDiff;
		uniform float4 _DiffuseColor1;
		uniform sampler2D _Diffuse1;
		uniform float4 _SecondaryTintDiff;
		uniform float4 _DiffuseColor2;
		uniform sampler2D _Diffuse2;
		uniform float4 _DecalColor;
		uniform float4 _Emission;
		uniform float4 _SpecularColor;
		uniform float4 _PrimaryTintSpec;
		uniform float4 _SpecularColor1;
		uniform sampler2D _Specular1;
		uniform float4 _SecondaryTintSpec;
		uniform float4 _SpecularColor2;
		uniform sampler2D _Specular2;


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

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float4 break49_g61338 = _DDNAColor;
			float3 appendResult50_g61338 = (float3(break49_g61338.r , break49_g61338.g , break49_g61338.b));
			float temp_output_2_0_g61268 = _LayerTiling1;
			float2 appendResult6_g61268 = (float2(temp_output_2_0_g61268 , temp_output_2_0_g61268));
			float2 temp_output_10_0_g61268 = ( _UVScale1 * appendResult6_g61268 );
			float2 uv_TexCoord3_g61268 = i.uv_texcoord * temp_output_10_0_g61268;
			float2 temp_output_10_0 = uv_TexCoord3_g61268;
			float n_Strength8 = _NormalStrength;
			float3 dynamicSwitch65 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA1 )
			{
				dynamicSwitch65 = UnpackScaleNormal( tex2D( _ddna1, temp_output_10_0 ), n_Strength8 );
			}
			else
			{
				dynamicSwitch65 = _DDNAColor1.rgb;
			}
			float4 break4_g61273 = _DetailColor1;
			float4 appendResult7_g61273 = (float4(break4_g61273.g , break4_g61273.a , break4_g61273.r , break4_g61273.b));
			float temp_output_2_0_g61267 = _DetailTiling1;
			float2 appendResult6_g61267 = (float2(temp_output_2_0_g61267 , temp_output_2_0_g61267));
			float2 temp_output_10_0_g61267 = ( _UVScale1 * appendResult6_g61267 );
			float2 uv_TexCoord3_g61267 = i.uv_texcoord * temp_output_10_0_g61267;
			float2 temp_output_1_0_g61273 = uv_TexCoord3_g61267;
			float3 tex2DNode5_g61273 = UnpackScaleNormal( tex2D( _Detail1, temp_output_1_0_g61273 ), n_Strength8 );
			float4 tex2DNode6_g61273 = tex2D( _Detail1, temp_output_1_0_g61273 );
			float4 appendResult8_g61273 = (float4(tex2DNode5_g61273.r , tex2DNode5_g61273.g , tex2DNode6_g61273.b , tex2DNode6_g61273.a));
			float4 dynamicSwitch56 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL1 )
			{
				dynamicSwitch56 = appendResult8_g61273;
			}
			else
			{
				dynamicSwitch56 = appendResult7_g61273;
			}
			float4 break42_g61297 = dynamicSwitch56;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61297 = ( break42_g61297.y * -1.0 );
			#else
				float staticSwitch31_g61297 = break42_g61297.y;
			#endif
			float3 appendResult23_g61297 = (float3(break42_g61297.x , staticSwitch31_g61297 , 0.5));
			float3 lerpResult35_g61296 = lerp( dynamicSwitch65 , appendResult23_g61297 , float3( 0.5,0.5,0.5 ));
			float temp_output_9_0_g61301 = break42_g61297.w;
			float3 temp_cast_2 = (temp_output_9_0_g61301).xxx;
			float3 temp_cast_3 = (temp_output_9_0_g61301).xxx;
			float3 linearToGamma15_g61301 = LinearToGammaSpace( temp_cast_3 );
			float dynamicSwitch55 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP1 )
			{
				dynamicSwitch55 = tex2D( _DDNAGlossmap1, temp_output_10_0 ).r;
			}
			else
			{
				dynamicSwitch55 = _DDNAColor1.a;
			}
			float blendOpSrc38_g61296 = _PrimaryTintGloss;
			float blendOpDest38_g61296 = dynamicSwitch55;
			float temp_output_8_0_g61301 = ( saturate( ( blendOpSrc38_g61296 * blendOpDest38_g61296 ) ));
			float3 temp_cast_4 = (temp_output_8_0_g61301).xxx;
			float3 temp_cast_5 = (temp_output_8_0_g61301).xxx;
			float3 linearToGamma14_g61301 = LinearToGammaSpace( temp_cast_5 );
			float3 temp_cast_6 = (temp_output_9_0_g61301).xxx;
			float3 blendOpSrc5_g61301 = linearToGamma14_g61301;
			float3 blendOpDest5_g61301 = linearToGamma15_g61301;
			float temp_output_2_0_g61301 = 0.0;
			float3 lerpResult6_g61301 = lerp( linearToGamma15_g61301 , ( saturate( (( blendOpDest5_g61301 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61301 ) * ( 1.0 - blendOpSrc5_g61301 ) ) : ( 2.0 * blendOpDest5_g61301 * blendOpSrc5_g61301 ) ) )) , saturate( temp_output_2_0_g61301 ));
			float3 gammaToLinear16_g61301 = GammaToLinearSpace( saturate( lerpResult6_g61301 ) );
			float4 appendResult37_g61296 = (float4(saturate( lerpResult35_g61296 ) , gammaToLinear16_g61301.x));
			float temp_output_2_0_g61270 = _LayerTiling2;
			float2 appendResult6_g61270 = (float2(temp_output_2_0_g61270 , temp_output_2_0_g61270));
			float2 temp_output_10_0_g61270 = ( _UVScale2 * appendResult6_g61270 );
			float2 uv_TexCoord3_g61270 = i.uv_texcoord * temp_output_10_0_g61270;
			float2 temp_output_16_0 = uv_TexCoord3_g61270;
			float3 dynamicSwitch59 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA2 )
			{
				dynamicSwitch59 = UnpackScaleNormal( tex2D( _ddna2, temp_output_16_0 ), n_Strength8 );
			}
			else
			{
				dynamicSwitch59 = _DDNAColor2.rgb;
			}
			float4 break4_g61272 = _DetailColor2;
			float4 appendResult7_g61272 = (float4(break4_g61272.g , break4_g61272.a , break4_g61272.r , break4_g61272.b));
			float temp_output_2_0_g61269 = _DetailTiling2;
			float2 appendResult6_g61269 = (float2(temp_output_2_0_g61269 , temp_output_2_0_g61269));
			float2 temp_output_10_0_g61269 = ( _UVScale2 * appendResult6_g61269 );
			float2 uv_TexCoord3_g61269 = i.uv_texcoord * temp_output_10_0_g61269;
			float2 temp_output_1_0_g61272 = uv_TexCoord3_g61269;
			float3 tex2DNode5_g61272 = UnpackScaleNormal( tex2D( _Detail2, temp_output_1_0_g61272 ), n_Strength8 );
			float4 tex2DNode6_g61272 = tex2D( _Detail2, temp_output_1_0_g61272 );
			float4 appendResult8_g61272 = (float4(tex2DNode5_g61272.r , tex2DNode5_g61272.g , tex2DNode6_g61272.b , tex2DNode6_g61272.a));
			float4 dynamicSwitch61 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL2 )
			{
				dynamicSwitch61 = appendResult8_g61272;
			}
			else
			{
				dynamicSwitch61 = appendResult7_g61272;
			}
			float4 break42_g61303 = dynamicSwitch61;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61303 = ( break42_g61303.y * -1.0 );
			#else
				float staticSwitch31_g61303 = break42_g61303.y;
			#endif
			float3 appendResult23_g61303 = (float3(break42_g61303.x , staticSwitch31_g61303 , 0.5));
			float3 lerpResult35_g61302 = lerp( dynamicSwitch59 , appendResult23_g61303 , float3( 0.5,0.5,0.5 ));
			float temp_output_9_0_g61307 = break42_g61303.w;
			float3 temp_cast_11 = (temp_output_9_0_g61307).xxx;
			float3 temp_cast_12 = (temp_output_9_0_g61307).xxx;
			float3 linearToGamma15_g61307 = LinearToGammaSpace( temp_cast_12 );
			float dynamicSwitch60 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP2 )
			{
				dynamicSwitch60 = tex2D( _DDNAGlossmap2, temp_output_16_0 ).r;
			}
			else
			{
				dynamicSwitch60 = _DDNAColor2.a;
			}
			float blendOpSrc38_g61302 = _SecondaryTintGloss;
			float blendOpDest38_g61302 = dynamicSwitch60;
			float temp_output_8_0_g61307 = ( saturate( ( blendOpSrc38_g61302 * blendOpDest38_g61302 ) ));
			float3 temp_cast_13 = (temp_output_8_0_g61307).xxx;
			float3 temp_cast_14 = (temp_output_8_0_g61307).xxx;
			float3 linearToGamma14_g61307 = LinearToGammaSpace( temp_cast_14 );
			float3 temp_cast_15 = (temp_output_9_0_g61307).xxx;
			float3 blendOpSrc5_g61307 = linearToGamma14_g61307;
			float3 blendOpDest5_g61307 = linearToGamma15_g61307;
			float temp_output_2_0_g61307 = 0.0;
			float3 lerpResult6_g61307 = lerp( linearToGamma15_g61307 , ( saturate( (( blendOpDest5_g61307 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61307 ) * ( 1.0 - blendOpSrc5_g61307 ) ) : ( 2.0 * blendOpDest5_g61307 * blendOpSrc5_g61307 ) ) )) , saturate( temp_output_2_0_g61307 ));
			float3 gammaToLinear16_g61307 = GammaToLinearSpace( saturate( lerpResult6_g61307 ) );
			float4 appendResult37_g61302 = (float4(saturate( lerpResult35_g61302 ) , gammaToLinear16_g61307.x));
			float clampResult11_g61345 = clamp( ( i.vertexColor.b + i.vertexColor.b ) , 0.0 , 1.0 );
			float dynamicSwitch78 = ( float )0;
			UNITY_BRANCH if ( _BLENDTEX1 )
			{
				dynamicSwitch78 = tex2D( _BlendTex1, temp_output_10_0 ).r;
			}
			else
			{
				dynamicSwitch78 = _BlendColor1;
			}
			float temp_output_6_0_g61344 = dynamicSwitch78;
			float mixFactor9_g61343 = ( saturate( ( clampResult11_g61345 * _WearLevel ) ) * temp_output_6_0_g61344 );
			float4 lerpResult15_g61343 = lerp( appendResult37_g61296 , appendResult37_g61302 , mixFactor9_g61343);
			float4 break31_g61343 = lerpResult15_g61343;
			float3 appendResult32_g61343 = (float3(break31_g61343.r , break31_g61343.g , break31_g61343.b));
			float3 lerpResult52_g61338 = lerp( appendResult50_g61338 , appendResult32_g61343 , float3( 0.5,0.5,0.5 ));
			float3 break3_g61341 = lerpResult52_g61338;
			float3 appendResult6_g61341 = (float3(( break3_g61341.y * 1.0 ) , ( break3_g61341.x * -1.0 ) , break3_g61341.z));
			float3 temp_output_53_0_g61338 = appendResult6_g61341;
			o.Normal = temp_output_53_0_g61338;
			float4 break41_g61338 = _DiffuseColor;
			float3 appendResult42_g61338 = (float3(break41_g61338.r , break41_g61338.g , break41_g61338.b));
			float3 hsvTorgb6_g61299 = RGBToHSV( _PrimaryTintDiff.rgb );
			float lerpResult8_g61299 = lerp( hsvTorgb6_g61299.z , 0.003 , ( hsvTorgb6_g61299.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61299 = HSVToRGB( float3(hsvTorgb6_g61299.x,hsvTorgb6_g61299.y,lerpResult8_g61299) );
			float4 dynamicSwitch53 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE1 )
			{
				dynamicSwitch53 = tex2D( _Diffuse1, temp_output_10_0 );
			}
			else
			{
				dynamicSwitch53 = _DiffuseColor1;
			}
			float4 break26_g61296 = dynamicSwitch53;
			float3 appendResult27_g61296 = (float3(break26_g61296.r , break26_g61296.g , break26_g61296.b));
			float3 blendOpSrc23_g61296 = hsvTorgb9_g61299;
			float3 blendOpDest23_g61296 = appendResult27_g61296;
			float3 temp_output_9_0_g61300 = saturate( ( saturate( ( blendOpSrc23_g61296 * blendOpDest23_g61296 ) )) );
			float4 color45_g61296 = IsGammaSpace() ? float4( 0.5, 0.5, 0.5, 0.5019608 ) : float4( 0.2140411, 0.2140411, 0.2140411, 0.5019608 );
			float3 temp_output_8_0_g61300 = color45_g61296.rgb;
			float3 linearToGamma14_g61300 = LinearToGammaSpace( temp_output_8_0_g61300 );
			float3 blendOpSrc5_g61300 = linearToGamma14_g61300;
			float3 blendOpDest5_g61300 = temp_output_9_0_g61300;
			float temp_output_2_0_g61300 = 0.0;
			float3 lerpResult6_g61300 = lerp( temp_output_9_0_g61300 , ( saturate( (( blendOpDest5_g61300 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61300 ) * ( 1.0 - blendOpSrc5_g61300 ) ) : ( 2.0 * blendOpDest5_g61300 * blendOpSrc5_g61300 ) ) )) , saturate( temp_output_2_0_g61300 ));
			float3 break29_g61296 = saturate( lerpResult6_g61300 );
			float4 appendResult28_g61296 = (float4(break29_g61296.x , break29_g61296.y , break29_g61296.z , break26_g61296.a));
			float3 hsvTorgb6_g61305 = RGBToHSV( _SecondaryTintDiff.rgb );
			float lerpResult8_g61305 = lerp( hsvTorgb6_g61305.z , 0.003 , ( hsvTorgb6_g61305.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61305 = HSVToRGB( float3(hsvTorgb6_g61305.x,hsvTorgb6_g61305.y,lerpResult8_g61305) );
			float4 dynamicSwitch57 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE2 )
			{
				dynamicSwitch57 = tex2D( _Diffuse2, temp_output_16_0 );
			}
			else
			{
				dynamicSwitch57 = _DiffuseColor2;
			}
			float4 break26_g61302 = dynamicSwitch57;
			float3 appendResult27_g61302 = (float3(break26_g61302.r , break26_g61302.g , break26_g61302.b));
			float3 blendOpSrc23_g61302 = hsvTorgb9_g61305;
			float3 blendOpDest23_g61302 = appendResult27_g61302;
			float3 temp_output_9_0_g61306 = saturate( ( saturate( ( blendOpSrc23_g61302 * blendOpDest23_g61302 ) )) );
			float4 color45_g61302 = IsGammaSpace() ? float4( 0.5, 0.5, 0.5, 0.5019608 ) : float4( 0.2140411, 0.2140411, 0.2140411, 0.5019608 );
			float3 temp_output_8_0_g61306 = color45_g61302.rgb;
			float3 linearToGamma14_g61306 = LinearToGammaSpace( temp_output_8_0_g61306 );
			float3 blendOpSrc5_g61306 = linearToGamma14_g61306;
			float3 blendOpDest5_g61306 = temp_output_9_0_g61306;
			float temp_output_2_0_g61306 = 0.0;
			float3 lerpResult6_g61306 = lerp( temp_output_9_0_g61306 , ( saturate( (( blendOpDest5_g61306 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61306 ) * ( 1.0 - blendOpSrc5_g61306 ) ) : ( 2.0 * blendOpDest5_g61306 * blendOpSrc5_g61306 ) ) )) , saturate( temp_output_2_0_g61306 ));
			float3 break29_g61302 = saturate( lerpResult6_g61306 );
			float4 appendResult28_g61302 = (float4(break29_g61302.x , break29_g61302.y , break29_g61302.z , break26_g61302.a));
			float4 lerpResult6_g61343 = lerp( appendResult28_g61296 , appendResult28_g61302 , mixFactor9_g61343);
			float4 break28_g61343 = lerpResult6_g61343;
			float3 appendResult29_g61343 = (float3(break28_g61343.r , break28_g61343.g , break28_g61343.b));
			float3 blendOpSrc39_g61338 = appendResult42_g61338;
			float3 blendOpDest39_g61338 = appendResult29_g61343;
			float3 lerpBlendMode39_g61338 = lerp(blendOpDest39_g61338,( blendOpSrc39_g61338 * blendOpDest39_g61338 ),break41_g61338.a);
			float3 temp_output_9_0_g61347 = saturate( ( saturate( lerpBlendMode39_g61338 )) );
			float4 break36_g61338 = _DecalColor;
			float3 appendResult37_g61338 = (float3(break36_g61338.r , break36_g61338.g , break36_g61338.b));
			float3 temp_output_8_0_g61347 = appendResult37_g61338;
			float3 blendOpSrc5_g61347 = temp_output_8_0_g61347;
			float3 blendOpDest5_g61347 = temp_output_9_0_g61347;
			float temp_output_2_0_g61347 = break36_g61338.a;
			float3 lerpResult6_g61347 = lerp( temp_output_9_0_g61347 , ( saturate( (( blendOpDest5_g61347 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61347 ) * ( 1.0 - blendOpSrc5_g61347 ) ) : ( 2.0 * blendOpDest5_g61347 * blendOpSrc5_g61347 ) ) )) , saturate( temp_output_2_0_g61347 ));
			float3 temp_output_74_0_g61338 = saturate( lerpResult6_g61347 );
			o.Albedo = temp_output_74_0_g61338;
			float4 break64_g61338 = _Emission;
			float3 appendResult65_g61338 = (float3(break64_g61338.r , break64_g61338.g , break64_g61338.b));
			float3 blendOpSrc62_g61338 = temp_output_74_0_g61338;
			float3 blendOpDest62_g61338 = appendResult65_g61338;
			float3 lerpBlendMode62_g61338 = lerp(blendOpDest62_g61338,( blendOpSrc62_g61338 * blendOpDest62_g61338 ),( 1.0 - break28_g61343.a ));
			float4 appendResult66_g61338 = (float4(( saturate( lerpBlendMode62_g61338 )) , ( break41_g61338.a * break64_g61338.a )));
			o.Emission = appendResult66_g61338.rgb;
			float4 temp_output_16_0_g61338 = _SpecularColor;
			float4 dynamicSwitch54 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR1 )
			{
				dynamicSwitch54 = tex2D( _Specular1, temp_output_10_0 );
			}
			else
			{
				dynamicSwitch54 = _SpecularColor1;
			}
			float3 hsvTorgb6_g61298 = RGBToHSV( dynamicSwitch54.rgb );
			float lerpResult8_g61298 = lerp( hsvTorgb6_g61298.z , 0.003 , ( hsvTorgb6_g61298.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61298 = HSVToRGB( float3(hsvTorgb6_g61298.x,hsvTorgb6_g61298.y,lerpResult8_g61298) );
			float4 blendOpSrc31_g61296 = _PrimaryTintSpec;
			float4 blendOpDest31_g61296 = float4( pow( hsvTorgb9_g61298 , 1.0 ) , 0.0 );
			float4 dynamicSwitch58 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR2 )
			{
				dynamicSwitch58 = tex2D( _Specular2, temp_output_16_0 );
			}
			else
			{
				dynamicSwitch58 = _SpecularColor2;
			}
			float3 hsvTorgb6_g61304 = RGBToHSV( dynamicSwitch58.rgb );
			float lerpResult8_g61304 = lerp( hsvTorgb6_g61304.z , 0.003 , ( hsvTorgb6_g61304.z < 0.003 ? 1.0 : 0.0 ));
			float3 hsvTorgb9_g61304 = HSVToRGB( float3(hsvTorgb6_g61304.x,hsvTorgb6_g61304.y,lerpResult8_g61304) );
			float4 blendOpSrc31_g61302 = _SecondaryTintSpec;
			float4 blendOpDest31_g61302 = float4( pow( hsvTorgb9_g61304 , 1.0 ) , 0.0 );
			float4 lerpResult19_g61343 = lerp( saturate( ( saturate( ( blendOpSrc31_g61296 * blendOpDest31_g61296 ) )) ) , saturate( ( saturate( ( blendOpSrc31_g61302 * blendOpDest31_g61302 ) )) ) , mixFactor9_g61343);
			float4 break37_g61343 = lerpResult19_g61343;
			float3 appendResult38_g61343 = (float3(break37_g61343.r , break37_g61343.g , break37_g61343.b));
			float4 blendOpSrc47_g61338 = temp_output_16_0_g61338;
			float4 blendOpDest47_g61338 = float4( appendResult38_g61343 , 0.0 );
			float4 lerpBlendMode47_g61338 = lerp(blendOpDest47_g61338,( blendOpSrc47_g61338 * blendOpDest47_g61338 ),( temp_output_16_0_g61338.r > float4( 0,0,0,0 ) ? 1.0 : 0.0 ));
			float3 linearToGamma76_g61338 = LinearToGammaSpace( ( saturate( lerpBlendMode47_g61338 )).rgb );
			o.Specular = linearToGamma76_g61338;
			float temp_output_9_0_g61346 = break31_g61343.a;
			float3 temp_cast_29 = (temp_output_9_0_g61346).xxx;
			float3 temp_cast_30 = (temp_output_9_0_g61346).xxx;
			float3 linearToGamma15_g61346 = LinearToGammaSpace( temp_cast_30 );
			float temp_output_8_0_g61346 = break49_g61338.a;
			float3 temp_cast_31 = (temp_output_8_0_g61346).xxx;
			float3 temp_cast_32 = (temp_output_8_0_g61346).xxx;
			float3 linearToGamma14_g61346 = LinearToGammaSpace( temp_cast_32 );
			float3 temp_cast_33 = (temp_output_9_0_g61346).xxx;
			float3 blendOpSrc5_g61346 = linearToGamma14_g61346;
			float3 blendOpDest5_g61346 = linearToGamma15_g61346;
			float temp_output_2_0_g61346 = 0.0;
			float3 lerpResult6_g61346 = lerp( linearToGamma15_g61346 , ( saturate( (( blendOpDest5_g61346 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61346 ) * ( 1.0 - blendOpSrc5_g61346 ) ) : ( 2.0 * blendOpDest5_g61346 * blendOpSrc5_g61346 ) ) )) , saturate( temp_output_2_0_g61346 ));
			float3 gammaToLinear16_g61346 = GammaToLinearSpace( lerpResult6_g61346 );
			float3 temp_output_75_0_g61338 = gammaToLinear16_g61346;
			o.Smoothness = temp_output_75_0_g61338.x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19904
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;-416,-96;Inherit;False;Property;_NormalStrength;Normal Strength;40;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-3776,-224;Inherit;False;Property;_LayerTiling1;Layer Tiling 1;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-3760,-96;Inherit;False;Property;_UVScale1;UV Scale 1;18;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-3792,32;Inherit;False;Property;_DetailTiling1;Detail Tiling 1;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-3856,1168;Inherit;False;Property;_LayerTiling2;Layer Tiling 2;36;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-3840,1280;Inherit;False;Property;_UVScale2;UV Scale 2;35;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-3872,1424;Inherit;False;Property;_DetailTiling2;Detail Tiling 2;37;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-192,-96;Inherit;False;n Strength;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-3568,-64;Inherit;False;SC Texture Tiling;-1;;61267;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-3552,-320;Inherit;False;SC Texture Tiling;-1;;61268;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-3104,-448;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-3216,224;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-3648,1328;Inherit;False;SC Texture Tiling;-1;;61269;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-3296,1616;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-3632,1072;Inherit;False;SC Texture Tiling;-1;;61270;c322e94f729c53e46a635469481d0bef;1,5,0;2;9;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-3184,944;Inherit;False;8;n Strength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-3328,1216;Inherit;False;Property;_DetailColor2;Detail Color 2;31;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-3248,-176;Inherit;False;Property;_DetailColor1;Detail Color 1;14;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-3328,1424;Inherit;True;Property;_Detail2;Detail 2;32;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-3248,32;Inherit;True;Property;_Detail1;Detail 1;15;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-2976,1456;Inherit;False;SC Detail Switcher;-1;;61272;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-2864,-816;Inherit;False;Property;_SpecularColor1;Specular Color 1;12;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-2944,576;Inherit;False;Property;_SpecularColor2;Specular Color 2;29;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-2976,384;Inherit;True;Property;_Diffuse2;Diffuse 2;25;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-2880,-624;Inherit;True;Property;_Specular1;Specular 1;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-2960,768;Inherit;True;Property;_Specular2;Specular 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;-2896,-1008;Inherit;True;Property;_Diffuse1;Diffuse 1;8;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-2896,64;Inherit;False;SC Detail Switcher;-1;;61273;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-2880,-144;Inherit;True;Property;_DDNAGlossmap1;DDNA Glossmap 1;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-2880,-416;Inherit;True;Property;_ddna1;ddna 1;10;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;-2960,1248;Inherit;True;Property;_DDNAGlossmap2;DDNA Glossmap 2;28;0;Create;True;0;0;0;False;0;False;22;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-2960,976;Inherit;True;Property;_ddna2;ddna 2;27;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-3136,-368;Inherit;False;Property;_DDNAColor1;DDNA Color 1;9;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;-3216,1024;Inherit;False;Property;_DDNAColor2;DDNA Color 2;26;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;-2832,-1088;Inherit;False;Property;_DiffuseColor1;Diffuse Color 1;7;1;[Gamma];Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-2912,304;Inherit;False;Property;_DiffuseColor2;Diffuse Color 2;24;1;[Gamma];Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-2080,0;Inherit;False;Property;_BlendColor1;Blend Color 1;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-2064,544;Inherit;False;Property;_BlendColor2;Blend Color 2;33;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-2624,416;Inherit;False;Property;_DiffuseTexture2;Diffuse Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-2448,-96;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;-2480,-208;Inherit;False;Property;_GlossmapTexture1;Glossmap Texture1;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-2480,-496;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;-2544,-752;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-2560,896;Inherit;False;Property;_SpecularTexture2;Specular Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-2560,1024;Inherit;False;Property;_DDNATexture2;DDNA Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-2560,1184;Inherit;False;Property;_GlossmapTexture2;Glossmap Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-2528,1296;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-2128,624;Inherit;True;Property;_BlendTex2;Blend Tex 2;34;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-2176,80;Inherit;True;Property;_BlendTex1;Blend Tex 1;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-2480,-368;Inherit;False;Property;_DDNATexture1;DDNA Texture 1;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-2480,272;Inherit;False;Property;_SecondaryTintGloss;Secondary Tint Gloss;23;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-2512,176;Inherit;False;Property;_SecondaryTintDiff;Secondary Tint Diff;21;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-2320,-848;Inherit;False;Property;_PrimaryTintDiff;Primary Tint Diff;4;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-2256,-752;Inherit;False;Property;_PrimaryTintGloss;Primary Tint Gloss;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-2288,-800;Inherit;False;Property;_PrimaryTintSpec;Primary Tint Spec;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-2480,224;Inherit;False;Property;_SecondaryTintSpec;Secondary Tint Spec;22;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-1712,-1248;Inherit;False;Property;_SpecularColor;Specular Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;71;-1728,928;Inherit;False;Property;_Emission;Emission;43;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;-1728,512;Inherit;False;Property;_BlendTexture2;Blend Texture 2;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_BLENDTEX2;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-1936,-256;Inherit;False;SC Tint;44;;61296;80e1f18b9d7c52c4fa81e9ff33b30a1d;0;8;15;COLOR;0,0,0,0;False;16;COLOR;0,0,0,0;False;17;FLOAT;0;False;12;COLOR;0,0,0,0;False;18;COLOR;0,0,0,0;False;6;FLOAT3;0,0,0;False;14;FLOAT;0;False;19;COLOR;0,0,0,0;False;5;COLOR;0;FLOAT;48;FLOAT4;1;FLOAT;46;COLOR;2
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;-1728,176;Inherit;False;Property;_BlendTexture1;Blend Texture 1;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_BLENDTEX1;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-2144,288;Inherit;False;SC Tint;44;;61302;80e1f18b9d7c52c4fa81e9ff33b30a1d;0;8;15;COLOR;0,0,0,0;False;16;COLOR;0,0,0,0;False;17;FLOAT;0;False;12;COLOR;0,0,0,0;False;18;COLOR;0,0,0,0;False;6;FLOAT3;0,0,0;False;14;FLOAT;0;False;19;COLOR;0,0,0,0;False;5;COLOR;0;FLOAT;48;FLOAT4;1;FLOAT;46;COLOR;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;69;-1696,768;Inherit;False;Property;_HeightBias;HeightBias;41;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;70;-1728,848;Inherit;False;Property;_POMDisplacement;POMDisplacement;42;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;72;-1728,608;Inherit;False;Property;_WearLevel;Wear Level;38;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-1424,-752;Inherit;False;Property;_DDNAColor;DDNA Color;1;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-1680,-1520;Inherit;False;Property;_DiffuseColor;Diffuse Color;0;1;[Gamma];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1376,-528;Inherit;False;Property;_DecalColor;Decal Color;3;0;Create;True;0;0;0;False;0;False;0.9490196,0.5568628,0.2117647,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-1664,688;Inherit;False;Property;_MetalTweak;Metal Tweak;39;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-432,0;Inherit;False;SC Hardsurface;-1;;61338;680409159c29bc74fbc71c8c0d7f1b99;1,23,0;19;18;COLOR;0,0,0,0;False;14;COLOR;0,0,0,0;False;15;COLOR;0.5,0.5,0.5,1;False;16;COLOR;0,0,0,0;False;17;COLOR;0,0,0,0;False;59;FLOAT;0;False;4;COLOR;0,0,0,0;False;5;COLOR;0.5,0.5,0.5,1;False;6;COLOR;0,0,0,0;False;12;FLOAT;0;False;7;COLOR;0,0,0,0;False;8;COLOR;0.5,0.5,0.5,1;False;9;COLOR;0,0,0,0;False;11;FLOAT;0;False;13;FLOAT;0;False;38;FLOAT;0;False;56;FLOAT;0;False;55;FLOAT;0;False;63;COLOR;0,0,0,0;False;6;FLOAT3;29;FLOAT3;67;FLOAT3;21;FLOAT3;32;COLOR;28;FLOAT3;19
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;0,0;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/HardSurface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;1;0
WireConnection;9;9;3;0
WireConnection;9;2;4;0
WireConnection;10;9;3;0
WireConnection;10;2;2;0
WireConnection;14;9;6;0
WireConnection;14;2;7;0
WireConnection;16;9;6;0
WireConnection;16;2;5;0
WireConnection;29;1;14;0
WireConnection;29;2;17;0
WireConnection;29;3;19;0
WireConnection;29;9;15;0
WireConnection;35;1;16;0
WireConnection;22;1;10;0
WireConnection;36;1;16;0
WireConnection;23;1;10;0
WireConnection;25;1;9;0
WireConnection;25;2;12;0
WireConnection;25;3;20;0
WireConnection;25;9;13;0
WireConnection;26;1;10;0
WireConnection;24;1;10;0
WireConnection;24;5;11;0
WireConnection;28;1;16;0
WireConnection;37;1;16;0
WireConnection;37;5;18;0
WireConnection;57;1;34;0
WireConnection;57;0;35;0
WireConnection;56;1;25;0
WireConnection;56;0;25;10
WireConnection;55;1;33;4
WireConnection;55;0;26;1
WireConnection;54;1;30;0
WireConnection;54;0;22;0
WireConnection;53;1;31;0
WireConnection;53;0;23;0
WireConnection;58;1;27;0
WireConnection;58;0;36;0
WireConnection;59;1;38;5
WireConnection;59;0;37;0
WireConnection;60;1;38;4
WireConnection;60;0;28;1
WireConnection;61;1;29;0
WireConnection;61;0;29;10
WireConnection;42;1;10;0
WireConnection;65;1;33;5
WireConnection;65;0;24;0
WireConnection;73;1;41;0
WireConnection;73;0;40;1
WireConnection;99;15;62;0
WireConnection;99;16;63;0
WireConnection;99;17;64;0
WireConnection;99;12;53;0
WireConnection;99;18;54;0
WireConnection;99;6;65;0
WireConnection;99;14;55;0
WireConnection;99;19;56;0
WireConnection;78;1;43;0
WireConnection;78;0;42;1
WireConnection;100;15;44;0
WireConnection;100;16;45;0
WireConnection;100;17;46;0
WireConnection;100;12;57;0
WireConnection;100;18;58;0
WireConnection;100;6;59;0
WireConnection;100;14;60;0
WireConnection;100;19;61;0
WireConnection;103;14;48;0
WireConnection;103;15;32;0
WireConnection;103;16;47;0
WireConnection;103;17;51;0
WireConnection;103;4;99;0
WireConnection;103;5;99;1
WireConnection;103;6;99;2
WireConnection;103;12;78;0
WireConnection;103;7;100;0
WireConnection;103;8;100;1
WireConnection;103;9;100;2
WireConnection;103;11;73;0
WireConnection;103;13;72;0
WireConnection;103;56;69;0
WireConnection;103;55;70;0
WireConnection;103;63;71;0
WireConnection;0;0;103;29
WireConnection;0;1;103;67
WireConnection;0;2;103;28
WireConnection;0;3;103;32
WireConnection;0;4;103;21
ASEEND*/
//CHKSM=C49C0AED6B1CD01B405C06A1DF53E46A775229AE