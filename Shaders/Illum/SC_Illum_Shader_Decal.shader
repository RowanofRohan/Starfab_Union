// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Illum (No Shadows)"
{
	Properties
	{
		[Gamma] _BaseColor( "Base Color", Color ) = ( 0.8, 0.8, 0.8, 1 )
		[Toggle( _FLIPGREENCHANNEL_ON )] _FlipGreenChannel( "Flip Green Channel", Float ) = 1
		[Gamma] _DiffuseColor( "Diffuse Color", Color ) = ( 0.5, 0.5, 0.5, 0 )
		[Gamma] _Diffuse( "Diffuse", 2D ) = "white" {}
		_DDNAColor( "DDNA Color", Color ) = ( 0.5, 0.5, 1, 0.5019608 )
		[Normal] _ddna( "ddna", 2D ) = "white" {}
		_DDNAGlossmap( "DDNA Glossmap", 2D ) = "white" {}
		_SpecularColor( "Specular Color", Color ) = ( 0, 0, 0, 1 )
		_Specular( "Specular", 2D ) = "white" {}
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
		_DetailDiffuseScale( "Detail Diffuse Scale", Float ) = 0
		_DetailGlossScale( "Detail Gloss Scale", Float ) = 0
		_Emission( "_Emission", Color ) = ( 0, 0, 0, 0 )
		[HideInInspector] GenKey__Blend( "Assign keyword _BLEND", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse( "Assign keyword _DIFFUSE", Float ) = 1.0
		[HideInInspector] GenKey__Detail( "Assign keyword _DETAIL", Float ) = 1.0
		[HideInInspector] GenKey__Decal( "Assign keyword _DECAL", Float ) = 1.0
		[HideInInspector] GenKey__ddna( "Assign keyword _DDNA", Float ) = 1.0
		[HideInInspector] GenKey__Specular( "Assign keyword _SPECULAR", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap( "Assign keyword _DDNAGLOSSMAP", Float ) = 1.0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 4.6
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma dynamic_branch _DDNA
		#pragma dynamic_branch _DETAIL
		#pragma shader_feature_local _FLIPGREENCHANNEL_ON
		#pragma dynamic_branch _BLEND
		#pragma dynamic_branch _DIFFUSE
		#pragma dynamic_branch _DECAL
		#pragma dynamic_branch _SPECULAR
		#pragma dynamic_branch _DDNAGLOSSMAP
		#define ASE_VERSION 19904
		#pragma surface surf StandardSpecular keepalpha nometa 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform float4 _Emission;
		uniform float4 _DDNAColor;
		uniform sampler2D _ddna;
		uniform float4 _ddna_ST;
		uniform float _NormalStrength;
		uniform float4 _DetailColor;
		uniform sampler2D _Detail;
		uniform float4 _BlendColor;
		uniform sampler2D _Blend;
		uniform float4 _Blend_ST;
		uniform float _BlendFactor;
		uniform float _BlendFalloff;
		uniform float4 _BaseColor;
		uniform float4 _DiffuseColor;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _BlendLayer2DiffuseColor;
		uniform float _DetailDiffuseScale;
		uniform float4 _DecalColor;
		uniform sampler2D _Decal;
		uniform float4 _Decal_ST;
		uniform float _Glow;
		uniform float4 _SpecularColor;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float4 _BlendLayer2SpecularColor;
		uniform sampler2D _DDNAGlossmap;
		uniform float4 _DDNAGlossmap_ST;
		uniform float _BlendLayer2Glossiness;
		uniform float _DetailGlossScale;
		uniform float _UseAlpha;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_ddna = i.uv_texcoord * _ddna_ST.xy + _ddna_ST.zw;
			float3 dynamicSwitch97 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA )
			{
				dynamicSwitch97 = UnpackScaleNormal( tex2D( _ddna, uv_ddna ), _NormalStrength );
			}
			else
			{
				dynamicSwitch97 = _DDNAColor.rgb;
			}
			float3 break3_g61273 = dynamicSwitch97;
			float3 appendResult6_g61273 = (float3(( break3_g61273.y * 1.0 ) , ( break3_g61273.x * -1.0 ) , break3_g61273.z));
			float4 break4_g61213 = _DetailColor;
			float4 appendResult7_g61213 = (float4(break4_g61213.g , break4_g61213.a , break4_g61213.r , break4_g61213.b));
			float2 temp_output_1_0_g61213 = float2( 1,1 );
			float3 tex2DNode5_g61213 = UnpackScaleNormal( tex2D( _Detail, temp_output_1_0_g61213 ), _NormalStrength );
			float4 tex2DNode6_g61213 = tex2D( _Detail, temp_output_1_0_g61213 );
			float4 appendResult8_g61213 = (float4(tex2DNode5_g61213.r , tex2DNode5_g61213.g , tex2DNode6_g61213.b , tex2DNode6_g61213.a));
			float4 dynamicSwitch129 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL )
			{
				dynamicSwitch129 = appendResult8_g61213;
			}
			else
			{
				dynamicSwitch129 = appendResult7_g61213;
			}
			float4 break42_g61265 = dynamicSwitch129;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61265 = ( break42_g61265.y * -1.0 );
			#else
				float staticSwitch31_g61265 = break42_g61265.y;
			#endif
			float3 appendResult23_g61265 = (float3(break42_g61265.x , staticSwitch31_g61265 , 0.5));
			float3 lerpResult46_g61261 = lerp( appendResult6_g61273 , appendResult23_g61265 , float3( 0.5,0.5,0.5 ));
			float3 ase_positionWS = i.worldPos;
			float3 temp_output_111_0_g61270 = ddx( ase_positionWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_113_0_g61270 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61270 = dot( temp_output_111_0_g61270 , temp_output_113_0_g61270 );
			float2 uv_Blend = i.uv_texcoord * _Blend_ST.xy + _Blend_ST.zw;
			float4 dynamicSwitch114 = ( float4 )0;
			UNITY_BRANCH if ( _BLEND )
			{
				dynamicSwitch114 = tex2D( _Blend, uv_Blend );
			}
			else
			{
				dynamicSwitch114 = _BlendColor;
			}
			float temp_output_6_0_g61264 = dynamicSwitch114.r;
			float temp_output_2_0_g61264 = ( ( temp_output_6_0_g61264 + ( _BlendFactor / 255.0 ) ) * ( _BlendFalloff / 255.0 ) );
			float blendFactor188_g61261 = saturate( temp_output_2_0_g61264 );
			float temp_output_20_0_g61270 = blendFactor188_g61261;
			float3 normalizeResult130_g61270 = normalize( ( ( abs( dotResult115_g61270 ) * ase_normalWS ) - ( 0.01 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61270 ) * ( ( ddx( temp_output_20_0_g61270 ) * temp_output_113_0_g61270 ) + ( ddy( temp_output_20_0_g61270 ) * cross( ase_normalWS , temp_output_111_0_g61270 ) ) ) ) ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_tangentWS, ase_bitangentWS, ase_normalWS );
			float3 worldToTangentDir42_g61270 = mul( ase_worldToTangent, normalizeResult130_g61270 );
			float3 temp_output_111_0_g61272 = ddx( ase_positionWS );
			float3 temp_output_113_0_g61272 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61272 = dot( temp_output_111_0_g61272 , temp_output_113_0_g61272 );
			float temp_output_29_0_g61261 = 0.0;
			float4 temp_output_8_0_g61261 = float4( 0,0,0,0 );
			float temp_output_28_0_g61261 = 0.0;
			float temp_output_20_0_g61272 = (  (0.0 + ( temp_output_8_0_g61261.r - 0.0 ) * ( 1.0 - 0.0 ) / ( temp_output_28_0_g61261 - 0.0 ) ) * blendFactor188_g61261 );
			float3 normalizeResult130_g61272 = normalize( ( ( abs( dotResult115_g61272 ) * ase_normalWS ) - ( temp_output_29_0_g61261 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61272 ) * ( ( ddx( temp_output_20_0_g61272 ) * temp_output_113_0_g61272 ) + ( ddy( temp_output_20_0_g61272 ) * cross( ase_normalWS , temp_output_111_0_g61272 ) ) ) ) ) );
			float3 worldToTangentDir42_g61272 = mul( ase_worldToTangent, normalizeResult130_g61272 );
			o.Normal = BlendNormals( BlendNormals( lerpResult46_g61261 , worldToTangentDir42_g61270 ) , worldToTangentDir42_g61272 );
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 dynamicSwitch96 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE )
			{
				dynamicSwitch96 = tex2D( _Diffuse, uv_Diffuse );
			}
			else
			{
				dynamicSwitch96 = _DiffuseColor;
			}
			float4 break252_g61261 = dynamicSwitch96;
			float3 appendResult253_g61261 = (float3(break252_g61261.r , break252_g61261.g , break252_g61261.b));
			float4 blendOpSrc1_g61261 = _BaseColor;
			float4 blendOpDest1_g61261 = float4( appendResult253_g61261 , 0.0 );
			float4 baseDiffuseMix197_g61261 = saturate( ( saturate( ( blendOpSrc1_g61261 * blendOpDest1_g61261 ) )) );
			float clampResult8_g61263 = clamp( blendFactor188_g61261 , 0.0 , 1.0 );
			float4 lerpResult1_g61263 = lerp( baseDiffuseMix197_g61261 , _BlendLayer2DiffuseColor , clampResult8_g61263);
			float4 clampResult14_g61263 = clamp( lerpResult1_g61263 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 temp_output_9_0_g61267 = clampResult14_g61263;
			float temp_output_8_0_g61267 = break42_g61265.z;
			float3 temp_cast_4 = (temp_output_8_0_g61267).xxx;
			float3 temp_cast_5 = (temp_output_8_0_g61267).xxx;
			float3 linearToGamma14_g61267 = LinearToGammaSpace( temp_cast_5 );
			float4 blendOpSrc5_g61267 = float4( linearToGamma14_g61267 , 0.0 );
			float4 blendOpDest5_g61267 = temp_output_9_0_g61267;
			float temp_output_2_0_g61267 = _DetailDiffuseScale;
			float4 lerpResult6_g61267 = lerp( temp_output_9_0_g61267 , ( saturate( (( blendOpDest5_g61267 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61267 ) * ( 1.0 - blendOpSrc5_g61267 ) ) : ( 2.0 * blendOpDest5_g61267 * blendOpSrc5_g61267 ) ) )) , saturate( temp_output_2_0_g61267 ));
			float4 temp_output_9_0_g61266 = saturate( lerpResult6_g61267 );
			float2 uv_Decal = i.uv_texcoord * _Decal_ST.xy + _Decal_ST.zw;
			float4 dynamicSwitch111 = ( float4 )0;
			UNITY_BRANCH if ( _DECAL )
			{
				dynamicSwitch111 = tex2D( _Decal, uv_Decal );
			}
			else
			{
				dynamicSwitch111 = _DecalColor;
			}
			float4 break255_g61261 = dynamicSwitch111;
			float3 appendResult254_g61261 = (float3(break255_g61261.r , break255_g61261.g , break255_g61261.b));
			float3 temp_output_8_0_g61266 = appendResult254_g61261;
			float4 blendOpSrc5_g61266 = float4( temp_output_8_0_g61266 , 0.0 );
			float4 blendOpDest5_g61266 = temp_output_9_0_g61266;
			float temp_output_2_0_g61266 = break255_g61261.a;
			float4 lerpResult6_g61266 = lerp( temp_output_9_0_g61266 , ( saturate( (( blendOpDest5_g61266 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61266 ) * ( 1.0 - blendOpSrc5_g61266 ) ) : ( 2.0 * blendOpDest5_g61266 * blendOpSrc5_g61266 ) ) )) , temp_output_2_0_g61266);
			float4 temp_output_314_0_g61261 = saturate( lerpResult6_g61266 );
			o.Albedo = temp_output_314_0_g61261.rgb;
			float diffuseAlpha193_g61261 = break252_g61261.a;
			float clampResult12_g61262 = clamp( ( i.vertexColor.g + i.vertexColor.g ) , 0.0 , 1.0 );
			o.Emission = ( ( baseDiffuseMix197_g61261 * diffuseAlpha193_g61261 ) * ( _Glow * diffuseAlpha193_g61261 * clampResult12_g61262 ) ).rgb;
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			float4 dynamicSwitch95 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR )
			{
				dynamicSwitch95 = tex2D( _Specular, uv_Specular );
			}
			else
			{
				dynamicSwitch95 = _SpecularColor;
			}
			float4 lerpResult9_g61263 = lerp( dynamicSwitch95 , _BlendLayer2SpecularColor , clampResult8_g61263);
			float4 clampResult15_g61263 = clamp( lerpResult9_g61263 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float3 linearToGamma321_g61261 = LinearToGammaSpace( clampResult15_g61263.rgb );
			o.Specular = linearToGamma321_g61261;
			float2 uv_DDNAGlossmap = i.uv_texcoord * _DDNAGlossmap_ST.xy + _DDNAGlossmap_ST.zw;
			float dynamicSwitch98 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP )
			{
				dynamicSwitch98 = tex2D( _DDNAGlossmap, uv_DDNAGlossmap ).a;
			}
			else
			{
				dynamicSwitch98 = _DDNAColor.a;
			}
			float lerpResult10_g61263 = lerp( dynamicSwitch98 , ( _BlendLayer2Glossiness / 255.0 ) , clampResult8_g61263);
			float clampResult16_g61263 = clamp( lerpResult10_g61263 , 0.0 , 1.0 );
			float temp_output_9_0_g61268 = clampResult16_g61263;
			float3 temp_cast_12 = (temp_output_9_0_g61268).xxx;
			float3 temp_cast_13 = (temp_output_9_0_g61268).xxx;
			float3 linearToGamma15_g61268 = LinearToGammaSpace( temp_cast_13 );
			float temp_output_8_0_g61268 = break42_g61265.w;
			float3 temp_cast_14 = (temp_output_8_0_g61268).xxx;
			float3 temp_cast_15 = (temp_output_8_0_g61268).xxx;
			float3 linearToGamma14_g61268 = LinearToGammaSpace( temp_cast_15 );
			float3 temp_cast_16 = (temp_output_9_0_g61268).xxx;
			float3 blendOpSrc5_g61268 = linearToGamma14_g61268;
			float3 blendOpDest5_g61268 = linearToGamma15_g61268;
			float temp_output_2_0_g61268 = _DetailGlossScale;
			float3 lerpResult6_g61268 = lerp( linearToGamma15_g61268 , ( saturate( (( blendOpDest5_g61268 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61268 ) * ( 1.0 - blendOpSrc5_g61268 ) ) : ( 2.0 * blendOpDest5_g61268 * blendOpSrc5_g61268 ) ) )) , saturate( temp_output_2_0_g61268 ));
			float3 gammaToLinear16_g61268 = GammaToLinearSpace( saturate( lerpResult6_g61268 ) );
			float3 temp_output_313_0_g61261 = gammaToLinear16_g61268;
			o.Smoothness =  (float3( 0,0,0 ) + ( temp_output_313_0_g61261 - float3( 1,0,0 ) ) * ( float3( 1,1,1 ) - float3( 0,0,0 ) ) / ( float3( 0,1,1 ) - float3( 1,0,0 ) ) ).x;
			float lerpResult161_g61261 = lerp( 1.0 , diffuseAlpha193_g61261 , saturate( _UseAlpha ));
			o.Alpha = saturate( lerpResult161_g61261 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19904
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-1824,-1760;Inherit;True;Property;_Detail;Detail;14;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-1824,-1968;Inherit;False;Property;_DetailColor;Detail Color;13;0;Create;True;0;0;0;False;0;False;0.9411765,0.7333333,1,0.5019608;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-2096,-1504;Inherit;False;Property;_NormalStrength;Normal Strength;26;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-1472,-1728;Inherit;False;SC Detail Switcher;-1;;61213;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-1440,-720;Inherit;True;Property;_DDNAGlossmap;DDNA Glossmap;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-1520,-1440;Inherit;True;Property;_Diffuse;Diffuse;5;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-1744,-624;Inherit;False;Property;_SpecularColor;Specular Color;9;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-1760,-432;Inherit;True;Property;_Specular;Specular;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-1600,112;Inherit;True;Property;_Decal;Decal;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;129;-1120,-1728;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-1440,-992;Inherit;True;Property;_ddna;ddna;7;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1488,-1488;Inherit;False;Property;_DiffuseColor;Diffuse Color;4;1;[Gamma];Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-1696,-944;Inherit;False;Property;_DDNAColor;DDNA Color;6;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,0.5019608;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-1840,48;Inherit;False;Property;_DecalColor;Decal Color;15;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-1488,320;Inherit;True;Property;_Blend;Blend;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-1792,288;Inherit;False;Property;_BlendColor;Blend Color;17;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1472,512;Inherit;False;Property;_BlendLayer2DiffuseColor;Blend Layer 2 Diffuse Color;19;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1456,784;Inherit;False;Property;_BlendFalloff;Blend Falloff;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1472,704;Inherit;False;Property;_BlendFactor;Blend Factor;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-1456,1632;Inherit;False;Property;_DetailDiffuseScale;Detail Diffuse Scale;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1456,1712;Inherit;False;Property;_DetailGlossScale;Detail Gloss Scale;31;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-1424,1232;Inherit;False;Property;_Glow;Glow;25;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-1440,1392;Inherit;False;Property;_UseAlpha;Use Alpha;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-1456,1072;Inherit;False;Property;_BlendLayer2Glossiness;Blend Layer 2 Glossiness;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-1488,864;Inherit;False;Property;_BlendLayer2SpecularColor;Blend Layer 2 Specular Color;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-1184,48;Inherit;False;Property;_DecalTexture;Decal Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DECAL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-1424,-496;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;-1040,-784;Inherit;False;Property;_GlossmapTexture;Glossmap Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;-1248,-1488;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;130;-912,-1728;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;-1040,-944;Inherit;False;Property;_DDNATexture;DDNA Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-1456,-1248;Inherit;False;Property;_BaseColor;Base Color;0;1;[Gamma];Create;True;0;0;0;False;0;False;0.8,0.8,0.8,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1120,288;Inherit;False;Property;_DecalTexture;Blend Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_BLEND;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1968,-240;Inherit;False;Property;_DispColor;Disp Color;11;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-1760,-176;Inherit;True;Property;_Disp;Disp;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1472,1552;Inherit;False;Property;_POMDisplacement;POM Displacement;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1360,-240;Inherit;False;Property;_DispTexture;Disp Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DISP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-1136,208;Inherit;False;Property;_MetalTweak;Metal Tweak;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;141;-592,0;Inherit;False;SC Illum;1;;61261;b8f56813ea575f54dae41b63a9c1c583;1,234,1;26;257;COLOR;0,0,0,0;False;152;COLOR;0,0,0,0;False;142;COLOR;0,0,0,0;False;2;COLOR;0,0,0,1;False;18;FLOAT;0;False;5;FLOAT3;0,0,0;False;6;FLOAT;0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;13;COLOR;0,0,0,0;False;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;COLOR;0,0,0,0;False;20;COLOR;0,0,0,0;False;21;FLOAT;0;False;22;COLOR;0,0,0,0;False;23;FLOAT;0;False;24;FLOAT;0;False;25;FLOAT;0;False;27;FLOAT;0;False;28;FLOAT;0;False;29;FLOAT;0;False;30;FLOAT;0;False;31;FLOAT;0;False;32;FLOAT;0;False;7;COLOR;176;FLOAT3;178;FLOAT3;180;FLOAT;160;FLOAT3;164;COLOR;154;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-1472,1472;Inherit;False;Property;_HeightBias;Height Bias;28;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;142;-847.8647,1087.118;Inherit;False;Property;_Emission;_Emission;33;0;Create;True;0;0;0;True;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;0,0;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/Illum (No Shadows);False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;True;True;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;32;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;137;2;33;0
WireConnection;137;3;115;0
WireConnection;137;9;46;0
WireConnection;129;1;137;0
WireConnection;129;0;137;10
WireConnection;104;5;46;0
WireConnection;111;1;112;0
WireConnection;111;0;110;0
WireConnection;95;1;61;0
WireConnection;95;0;60;0
WireConnection;98;1;102;4
WireConnection;98;0;99;4
WireConnection;96;1;100;0
WireConnection;96;0;103;0
WireConnection;130;0;129;0
WireConnection;97;1;102;5
WireConnection;97;0;104;0
WireConnection;114;1;113;0
WireConnection;114;0;54;0
WireConnection;108;1;109;0
WireConnection;108;0;107;0
WireConnection;141;257;130;0
WireConnection;141;152;111;0
WireConnection;141;142;96;0
WireConnection;141;2;37;0
WireConnection;141;5;97;0
WireConnection;141;6;98;0
WireConnection;141;7;95;0
WireConnection;141;13;114;0
WireConnection;141;14;39;0
WireConnection;141;15;40;0
WireConnection;141;16;41;0
WireConnection;141;20;42;0
WireConnection;141;21;43;0
WireConnection;141;25;45;0
WireConnection;141;27;47;0
WireConnection;141;30;50;0
WireConnection;141;31;51;0
WireConnection;27;0;141;154
WireConnection;27;1;141;164
WireConnection;27;2;141;0
WireConnection;27;3;141;180
WireConnection;27;4;141;178
WireConnection;27;9;141;160
ASEEND*/
//CHKSM=31D02C09F8D55C7A509399373BDC89FCF61D1AAF