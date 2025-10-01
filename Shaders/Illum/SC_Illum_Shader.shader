// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Illum"
{
	Properties
	{
		[Gamma] _BaseColor( "Base Color", Color ) = ( 0.8, 0.8, 0.8, 1 )
		[Toggle( _FLIPGREENCHANNEL_ON )] _FlipGreenChannel( "Flip Green Channel", Float ) = 1
		[Gamma] _DiffuseColor( "Diffuse Color", Color ) = ( 0.5, 0.5, 0.5, 0 )
		[Gamma] _Diffuse( "Diffuse", 2D ) = "white" {}
		_DDNAColor( "DDNA Color", Color ) = ( 0.5, 0.5, 1, 0.5019608 )
		[Normal] _ddna( "ddna", 2D ) = "bump" {}
		_DDNAGlossmap( "DDNA Glossmap", 2D ) = "white" {}
		_SpecularColor( "Specular Color", Color ) = ( 0, 0, 0, 1 )
		_Specular( "Specular", 2D ) = "white" {}
		_DispColor( "Disp Color", Color ) = ( 0, 0, 0, 1 )
		_Disp( "Disp", 2D ) = "white" {}
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
		[HideInInspector] GenKey__Specular( "Assign keyword _SPECULAR", Float ) = 1.0
		[HideInInspector] GenKey__Disp( "Assign keyword _DISP", Float ) = 1.0
		[HideInInspector] GenKey__Diffuse( "Assign keyword _DIFFUSE", Float ) = 1.0
		[HideInInspector] GenKey__Blend( "Assign keyword _BLEND", Float ) = 1.0
		[HideInInspector] GenKey__Detail( "Assign keyword _DETAIL", Float ) = 1.0
		[HideInInspector] GenKey__ddna( "Assign keyword _DDNA", Float ) = 1.0
		[HideInInspector] GenKey__Decal( "Assign keyword _DECAL", Float ) = 1.0
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
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma dynamic_branch _DDNA
		#pragma dynamic_branch _DETAIL
		#pragma shader_feature_local _FLIPGREENCHANNEL_ON
		#pragma dynamic_branch _BLEND
		#pragma dynamic_branch _DISP
		#pragma dynamic_branch _DIFFUSE
		#pragma dynamic_branch _DECAL
		#pragma dynamic_branch _SPECULAR
		#pragma dynamic_branch _DDNAGLOSSMAP
		#define ASE_VERSION 19904
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
			float4 vertexColor : COLOR;
		};

		uniform float4 _DDNAColor;
		uniform sampler2D _ddna;
		uniform float4 _ddna_ST;
		uniform float _NormalStrength;
		uniform float4 _DetailColor;
		uniform sampler2D _Detail;
		uniform float4 _Detail_ST;
		uniform float4 _BlendColor;
		uniform sampler2D _Blend;
		uniform float4 _Blend_ST;
		uniform float _BlendFactor;
		uniform float _BlendFalloff;
		uniform float _POMDisplacement;
		uniform float4 _DispColor;
		uniform sampler2D _Disp;
		uniform float4 _Disp_ST;
		uniform float _HeightBias;
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
			float3 break3_g61502 = dynamicSwitch97;
			float3 appendResult6_g61502 = (float3(( break3_g61502.y * 1.0 ) , ( break3_g61502.x * -1.0 ) , break3_g61502.z));
			float4 break4_g61420 = _DetailColor;
			float4 appendResult7_g61420 = (float4(break4_g61420.g , break4_g61420.a , break4_g61420.r , break4_g61420.b));
			float2 uv_Detail = i.uv_texcoord * _Detail_ST.xy + _Detail_ST.zw;
			float2 temp_output_1_0_g61420 = uv_Detail;
			float3 tex2DNode5_g61420 = UnpackScaleNormal( tex2D( _Detail, temp_output_1_0_g61420 ), _NormalStrength );
			float4 tex2DNode6_g61420 = tex2D( _Detail, temp_output_1_0_g61420 );
			float4 appendResult8_g61420 = (float4(tex2DNode5_g61420.r , tex2DNode5_g61420.g , tex2DNode6_g61420.b , tex2DNode6_g61420.a));
			float4 dynamicSwitch129 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL )
			{
				dynamicSwitch129 = appendResult8_g61420;
			}
			else
			{
				dynamicSwitch129 = appendResult7_g61420;
			}
			float4 break42_g61494 = dynamicSwitch129;
			#ifdef _FLIPGREENCHANNEL_ON
				float staticSwitch31_g61494 = ( break42_g61494.y * -1.0 );
			#else
				float staticSwitch31_g61494 = break42_g61494.y;
			#endif
			float3 appendResult23_g61494 = (float3(break42_g61494.x , staticSwitch31_g61494 , 0.5));
			float3 lerpResult46_g61490 = lerp( appendResult6_g61502 , appendResult23_g61494 , float3( 0.5,0.5,0.5 ));
			float3 ase_positionWS = i.worldPos;
			float3 temp_output_111_0_g61499 = ddx( ase_positionWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_113_0_g61499 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61499 = dot( temp_output_111_0_g61499 , temp_output_113_0_g61499 );
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
			float temp_output_6_0_g61493 = dynamicSwitch114.r;
			float temp_output_2_0_g61493 = ( ( temp_output_6_0_g61493 + ( _BlendFactor / 255.0 ) ) * ( _BlendFalloff / 255.0 ) );
			float blendFactor188_g61490 = saturate( temp_output_2_0_g61493 );
			float temp_output_20_0_g61499 = blendFactor188_g61490;
			float3 normalizeResult130_g61499 = normalize( ( ( abs( dotResult115_g61499 ) * ase_normalWS ) - ( 0.01 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61499 ) * ( ( ddx( temp_output_20_0_g61499 ) * temp_output_113_0_g61499 ) + ( ddy( temp_output_20_0_g61499 ) * cross( ase_normalWS , temp_output_111_0_g61499 ) ) ) ) ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_tangentWS, ase_bitangentWS, ase_normalWS );
			float3 worldToTangentDir42_g61499 = mul( ase_worldToTangent, normalizeResult130_g61499 );
			float3 temp_output_111_0_g61501 = ddx( ase_positionWS );
			float3 temp_output_113_0_g61501 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61501 = dot( temp_output_111_0_g61501 , temp_output_113_0_g61501 );
			float temp_output_29_0_g61490 = _POMDisplacement;
			float2 uv_Disp = i.uv_texcoord * _Disp_ST.xy + _Disp_ST.zw;
			float4 dynamicSwitch108 = ( float4 )0;
			UNITY_BRANCH if ( _DISP )
			{
				dynamicSwitch108 = tex2D( _Disp, uv_Disp );
			}
			else
			{
				dynamicSwitch108 = _DispColor;
			}
			float4 temp_output_8_0_g61490 = dynamicSwitch108;
			float temp_output_28_0_g61490 = _HeightBias;
			float temp_output_20_0_g61501 = (  (0.0 + ( temp_output_8_0_g61490.r - 0.0 ) * ( 1.0 - 0.0 ) / ( temp_output_28_0_g61490 - 0.0 ) ) * blendFactor188_g61490 );
			float3 normalizeResult130_g61501 = normalize( ( ( abs( dotResult115_g61501 ) * ase_normalWS ) - ( temp_output_29_0_g61490 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61501 ) * ( ( ddx( temp_output_20_0_g61501 ) * temp_output_113_0_g61501 ) + ( ddy( temp_output_20_0_g61501 ) * cross( ase_normalWS , temp_output_111_0_g61501 ) ) ) ) ) );
			float3 worldToTangentDir42_g61501 = mul( ase_worldToTangent, normalizeResult130_g61501 );
			o.Normal = BlendNormals( BlendNormals( lerpResult46_g61490 , worldToTangentDir42_g61499 ) , worldToTangentDir42_g61501 );
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
			float4 break252_g61490 = dynamicSwitch96;
			float3 appendResult253_g61490 = (float3(break252_g61490.r , break252_g61490.g , break252_g61490.b));
			float4 blendOpSrc1_g61490 = _BaseColor;
			float4 blendOpDest1_g61490 = float4( appendResult253_g61490 , 0.0 );
			float4 baseDiffuseMix197_g61490 = saturate( ( saturate( ( blendOpSrc1_g61490 * blendOpDest1_g61490 ) )) );
			float clampResult8_g61492 = clamp( blendFactor188_g61490 , 0.0 , 1.0 );
			float4 lerpResult1_g61492 = lerp( baseDiffuseMix197_g61490 , _BlendLayer2DiffuseColor , clampResult8_g61492);
			float4 clampResult14_g61492 = clamp( lerpResult1_g61492 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 temp_output_9_0_g61496 = clampResult14_g61492;
			float temp_output_8_0_g61496 = break42_g61494.z;
			float3 temp_cast_4 = (temp_output_8_0_g61496).xxx;
			float3 temp_cast_5 = (temp_output_8_0_g61496).xxx;
			float3 linearToGamma14_g61496 = LinearToGammaSpace( temp_cast_5 );
			float4 blendOpSrc5_g61496 = float4( linearToGamma14_g61496 , 0.0 );
			float4 blendOpDest5_g61496 = temp_output_9_0_g61496;
			float temp_output_2_0_g61496 = _DetailDiffuseScale;
			float4 lerpResult6_g61496 = lerp( temp_output_9_0_g61496 , ( saturate( (( blendOpDest5_g61496 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61496 ) * ( 1.0 - blendOpSrc5_g61496 ) ) : ( 2.0 * blendOpDest5_g61496 * blendOpSrc5_g61496 ) ) )) , saturate( temp_output_2_0_g61496 ));
			float4 temp_output_9_0_g61495 = saturate( lerpResult6_g61496 );
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
			float4 break255_g61490 = dynamicSwitch111;
			float3 appendResult254_g61490 = (float3(break255_g61490.r , break255_g61490.g , break255_g61490.b));
			float3 temp_output_8_0_g61495 = appendResult254_g61490;
			float4 blendOpSrc5_g61495 = float4( temp_output_8_0_g61495 , 0.0 );
			float4 blendOpDest5_g61495 = temp_output_9_0_g61495;
			float temp_output_2_0_g61495 = break255_g61490.a;
			float4 lerpResult6_g61495 = lerp( temp_output_9_0_g61495 , ( saturate( (( blendOpDest5_g61495 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61495 ) * ( 1.0 - blendOpSrc5_g61495 ) ) : ( 2.0 * blendOpDest5_g61495 * blendOpSrc5_g61495 ) ) )) , temp_output_2_0_g61495);
			float4 temp_output_314_0_g61490 = saturate( lerpResult6_g61495 );
			o.Albedo = temp_output_314_0_g61490.rgb;
			float diffuseAlpha193_g61490 = break252_g61490.a;
			float clampResult12_g61491 = clamp( ( i.vertexColor.g + i.vertexColor.g ) , 0.0 , 1.0 );
			o.Emission = ( ( baseDiffuseMix197_g61490 * diffuseAlpha193_g61490 ) * ( _Glow * diffuseAlpha193_g61490 * clampResult12_g61491 ) ).rgb;
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
			float4 lerpResult9_g61492 = lerp( dynamicSwitch95 , _BlendLayer2SpecularColor , clampResult8_g61492);
			float4 clampResult15_g61492 = clamp( lerpResult9_g61492 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float3 linearToGamma321_g61490 = LinearToGammaSpace( clampResult15_g61492.rgb );
			o.Specular = linearToGamma321_g61490;
			float2 uv_DDNAGlossmap = i.uv_texcoord * _DDNAGlossmap_ST.xy + _DDNAGlossmap_ST.zw;
			float dynamicSwitch98 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP )
			{
				dynamicSwitch98 = tex2D( _DDNAGlossmap, uv_DDNAGlossmap ).r;
			}
			else
			{
				dynamicSwitch98 = _DDNAColor.a;
			}
			float lerpResult10_g61492 = lerp( dynamicSwitch98 , ( _BlendLayer2Glossiness / 255.0 ) , clampResult8_g61492);
			float clampResult16_g61492 = clamp( lerpResult10_g61492 , 0.0 , 1.0 );
			float temp_output_9_0_g61497 = clampResult16_g61492;
			float3 temp_cast_12 = (temp_output_9_0_g61497).xxx;
			float3 temp_cast_13 = (temp_output_9_0_g61497).xxx;
			float3 linearToGamma15_g61497 = LinearToGammaSpace( temp_cast_13 );
			float temp_output_8_0_g61497 = break42_g61494.w;
			float3 temp_cast_14 = (temp_output_8_0_g61497).xxx;
			float3 temp_cast_15 = (temp_output_8_0_g61497).xxx;
			float3 linearToGamma14_g61497 = LinearToGammaSpace( temp_cast_15 );
			float3 temp_cast_16 = (temp_output_9_0_g61497).xxx;
			float3 blendOpSrc5_g61497 = linearToGamma14_g61497;
			float3 blendOpDest5_g61497 = linearToGamma15_g61497;
			float temp_output_2_0_g61497 = _DetailGlossScale;
			float3 lerpResult6_g61497 = lerp( linearToGamma15_g61497 , ( saturate( (( blendOpDest5_g61497 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest5_g61497 ) * ( 1.0 - blendOpSrc5_g61497 ) ) : ( 2.0 * blendOpDest5_g61497 * blendOpSrc5_g61497 ) ) )) , saturate( temp_output_2_0_g61497 ));
			float3 gammaToLinear16_g61497 = GammaToLinearSpace( saturate( lerpResult6_g61497 ) );
			float3 temp_output_313_0_g61490 = gammaToLinear16_g61497;
			o.Smoothness = temp_output_313_0_g61490.x;
			float lerpResult161_g61490 = lerp( 1.0 , diffuseAlpha193_g61490 , saturate( _UseAlpha ));
			o.Alpha = saturate( lerpResult161_g61490 );
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
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-2016,-1760;Inherit;True;Property;_Detail;Detail;15;0;Create;True;0;0;0;False;0;False;None;43dbcf1df1cc7844cb4afb1430ad687d;True;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-2096,-1504;Inherit;False;Property;_NormalStrength;Normal Strength;27;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;162;-1760,-1760;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-1824,-1968;Inherit;False;Property;_DetailColor;Detail Color;14;0;Create;True;0;0;0;False;0;False;0.9411765,0.7333333,1,0.5019608;0.9411765,0.7333333,1,0.5019608;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;166;-1472,-1728;Inherit;False;SC Detail Switcher;-1;;61420;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-1744,-624;Inherit;False;Property;_SpecularColor;Specular Color;10;0;Create;True;0;0;0;False;0;False;0,0,0,1;0.03560132,0.03560132,0.03560132,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-1760,-432;Inherit;True;Property;_Specular;Specular;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1968,-240;Inherit;False;Property;_DispColor;Disp Color;12;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-1760,-176;Inherit;True;Property;_Disp;Disp;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-1600,112;Inherit;True;Property;_Decal;Decal;17;0;Create;True;0;0;0;False;0;False;-1;None;38725d31faf27014883cd1eb0588d54e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;129;-1120,-1728;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-1520,-1440;Inherit;True;Property;_Diffuse;Diffuse;6;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;38725d31faf27014883cd1eb0588d54e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-1440,-720;Inherit;True;Property;_DDNAGlossmap;DDNA Glossmap;9;0;Create;True;0;0;0;False;0;False;-1;None;eb1dea9f5180caa458037af2b5aa1c7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-1440,-992;Inherit;True;Property;_ddna;ddna;8;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;31b2e730dc5e31d4aa3b6a4b2e839e8d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-1696,-944;Inherit;False;Property;_DDNAColor;DDNA Color;7;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,0.5019608;0.001960784,0.001960784,0.003921569,0.627451;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1488,-1584;Inherit;False;Property;_DiffuseColor;Diffuse Color;5;1;[Gamma];Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0;0.5,0.5,0.5,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-1840,48;Inherit;False;Property;_DecalColor;Decal Color;16;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-1488,320;Inherit;True;Property;_Blend;Blend;19;0;Create;True;0;0;0;False;0;False;-1;None;c3a0eade880a30247a21225f92b336cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-1792,288;Inherit;False;Property;_BlendColor;Blend Color;18;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1472,512;Inherit;False;Property;_BlendLayer2DiffuseColor;Blend Layer 2 Diffuse Color;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1456,784;Inherit;False;Property;_BlendFalloff;Blend Falloff;24;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1472,704;Inherit;False;Property;_BlendFactor;Blend Factor;23;0;Create;True;0;0;0;False;0;False;0;2.40899;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-1456,1632;Inherit;False;Property;_DetailDiffuseScale;Detail Diffuse Scale;31;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1456,1712;Inherit;False;Property;_DetailGlossScale;Detail Gloss Scale;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-1424,1232;Inherit;False;Property;_Glow;Glow;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-1440,1392;Inherit;False;Property;_UseAlpha;Use Alpha;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1472,1552;Inherit;False;Property;_POMDisplacement;POM Displacement;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-1456,1072;Inherit;False;Property;_BlendLayer2Glossiness;Blend Layer 2 Glossiness;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-1488,864;Inherit;False;Property;_BlendLayer2SpecularColor;Blend Layer 2 Specular Color;21;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.04518618,0.04518618,0.04518618,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;130;-912,-1728;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-1184,48;Inherit;False;Property;_DecalTexture;Decal Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DECAL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;-1248,-1488;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-1424,-496;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1392,-240;Inherit;False;Property;_DispTexture;Disp Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DISP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;-1040,-944;Inherit;False;Property;_DDNATexture;DDNA Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;-1040,-784;Inherit;False;Property;_GlossmapTexture;Glossmap Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-1456,-1248;Inherit;False;Property;_BaseColor;Base Color;0;1;[Gamma];Create;True;0;0;0;False;0;False;0.8,0.8,0.8,1;0.7960784,0.7294118,0.6823529,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-1472,1472;Inherit;False;Property;_HeightBias;Height Bias;29;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1120,288;Inherit;False;Property;_BlendTexture;Blend Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_BLEND;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-1136,208;Inherit;False;Property;_Metalness;Metal Tweak;25;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;197;-592,0;Inherit;True;SC Illum;1;;61490;b8f56813ea575f54dae41b63a9c1c583;1,234,0;26;257;COLOR;0,0,0,0;False;152;COLOR;0,0,0,0;False;142;COLOR;0,0,0,0;False;2;COLOR;0,0,0,1;False;18;FLOAT;0;False;5;FLOAT3;0,0,0;False;6;FLOAT;0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;13;COLOR;0,0,0,0;False;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;COLOR;0,0,0,0;False;20;COLOR;0,0,0,0;False;21;FLOAT;0;False;22;COLOR;0,0,0,0;False;23;FLOAT;0;False;24;FLOAT;0;False;25;FLOAT;0;False;27;FLOAT;0;False;28;FLOAT;0;False;29;FLOAT;0;False;30;FLOAT;0;False;31;FLOAT;0;False;32;FLOAT;0;False;7;COLOR;176;FLOAT3;178;FLOAT3;180;FLOAT;160;FLOAT3;164;COLOR;154;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;198;-672,912;Inherit;False;Property;_Emission;_Emission;33;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;160;0,0;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/Illum;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;True;True;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;4;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;162;2;33;0
WireConnection;166;1;162;0
WireConnection;166;2;33;0
WireConnection;166;3;115;0
WireConnection;166;9;46;0
WireConnection;129;1;166;0
WireConnection;129;0;166;10
WireConnection;104;5;46;0
WireConnection;130;0;129;0
WireConnection;111;1;112;0
WireConnection;111;0;110;0
WireConnection;96;1;100;0
WireConnection;96;0;103;0
WireConnection;95;1;61;0
WireConnection;95;0;60;0
WireConnection;108;1;109;0
WireConnection;108;0;107;0
WireConnection;97;1;102;5
WireConnection;97;0;104;0
WireConnection;98;1;102;4
WireConnection;98;0;99;1
WireConnection;114;1;113;0
WireConnection;114;0;54;0
WireConnection;197;257;130;0
WireConnection;197;152;111;0
WireConnection;197;142;96;0
WireConnection;197;2;37;0
WireConnection;197;5;97;0
WireConnection;197;6;98;0
WireConnection;197;7;95;0
WireConnection;197;8;108;0
WireConnection;197;13;114;0
WireConnection;197;14;39;0
WireConnection;197;15;40;0
WireConnection;197;16;41;0
WireConnection;197;20;42;0
WireConnection;197;21;43;0
WireConnection;197;25;45;0
WireConnection;197;27;47;0
WireConnection;197;28;48;0
WireConnection;197;29;49;0
WireConnection;197;30;50;0
WireConnection;197;31;51;0
WireConnection;160;0;197;154
WireConnection;160;1;197;164
WireConnection;160;2;197;0
WireConnection;160;3;197;180
WireConnection;160;4;197;178
WireConnection;160;9;197;160
ASEEND*/
//CHKSM=4FAE462DB3D6649248F9E049C5E295D37A1BFCBD