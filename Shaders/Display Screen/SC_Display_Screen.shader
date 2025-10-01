// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Display Screen"
{
	Properties
	{
		[Gamma] _BaseColor( "Base Color", Color ) = ( 0, 0, 0, 0.2 )
		[Gamma] _DiffuseColor( "Diffuse Color", Color ) = ( 0, 0, 0, 0.01960784 )
		[Gamma] _Diffuse( "Diffuse", 2D ) = "white" {}
		_DDNAColor( "DDNA Color", Color ) = ( 0.5, 0.5, 1, 0.9686275 )
		[Normal] _ddna( "ddna", 2D ) = "bump" {}
		_DDNAGlossmap( "DDNA Glossmap", 2D ) = "white" {}
		_SpecularColor( "Specular Color", Color ) = ( 0.5, 0.5, 0.5, 1 )
		_Specular( "Specular", 2D ) = "white" {}
		_DispColor( "Disp Color", Color ) = ( 0, 0, 0, 1 )
		_Disp( "Disp", 2D ) = "white" {}
		_DetailColor( "Detail Color", Color ) = ( 0, 0, 0, 1 )
		_Detail( "Detail", 2D ) = "white" {}
		_DecalColor( "Decal Color", Color ) = ( 0.9490196, 0.5568628, 0.2117647, 0 )
		_Decal( "Decal", 2D ) = "white" {}
		_Blend( "Blend", 2D ) = "white" {}
		_BlendColor( "Blend Color", Color ) = ( 0, 0, 0, 1 )
		_BlendLayer2DiffuseColor( "Blend Layer 2 Diffuse Color", Color ) = ( 0, 0, 0, 0 )
		_BlendLayer2SpecularColor( "Blend Layer 2 Specular Color", Color ) = ( 0, 0, 0, 0 )
		_BlendLayer2Glossiness( "Blend Layer 2 Glossiness", Float ) = 0
		_BlendFactor( "Blend Factor", Float ) = 0
		_Glow( "Glow", Float ) = 64
		_NormalStrength( "Normal Strength", Float ) = 1
		_UseAlpha( "Use Alpha", Float ) = 1
		_HeightBias( "Height Bias", Float ) = 0.5
		_POMDisplacement( "POM Displacement", Float ) = 0
		[HideInInspector] GenKey__Diffuse( "Assign keyword _DIFFUSE", Float ) = 1.0
		[HideInInspector] GenKey__DDNAGlossmap( "Assign keyword _DDNAGLOSSMAP", Float ) = 1.0
		[HideInInspector] GenKey__Detail( "Assign keyword _DETAIL", Float ) = 1.0
		[HideInInspector] GenKey__Decal( "Assign keyword _DECAL", Float ) = 1.0
		[HideInInspector] GenKey__Blend( "Assign keyword _BLEND", Float ) = 1.0
		[HideInInspector] GenKey__Specular( "Assign keyword _SPECULAR", Float ) = 1.0
		[HideInInspector] GenKey__Disp( "Assign keyword _DISP", Float ) = 1.0
		[HideInInspector] GenKey__ddna( "Assign keyword _DDNA", Float ) = 1.0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
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
		#pragma dynamic_branch _DISP
		#pragma dynamic_branch _BLEND
		#pragma dynamic_branch _DIFFUSE
		#pragma dynamic_branch _DECAL
		#pragma dynamic_branch _SPECULAR
		#pragma dynamic_branch _DETAIL
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
		uniform float _POMDisplacement;
		uniform float4 _DispColor;
		uniform sampler2D _Disp;
		uniform float4 _Disp_ST;
		uniform float _HeightBias;
		uniform float4 _BlendColor;
		uniform sampler2D _Blend;
		uniform float4 _Blend_ST;
		uniform float _BlendFactor;
		uniform float4 _BaseColor;
		uniform float4 _DiffuseColor;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _BlendLayer2DiffuseColor;
		uniform float4 _DecalColor;
		uniform sampler2D _Decal;
		uniform float4 _Decal_ST;
		uniform float _Glow;
		uniform float4 _SpecularColor;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float4 _BlendLayer2SpecularColor;
		uniform float4 _DetailColor;
		uniform sampler2D _Detail;
		uniform float4 _Detail_ST;
		uniform sampler2D _DDNAGlossmap;
		uniform float4 _DDNAGlossmap_ST;
		uniform float _BlendLayer2Glossiness;
		uniform float _UseAlpha;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_ddna = i.uv_texcoord * _ddna_ST.xy + _ddna_ST.zw;
			float3 dynamicSwitch42 = ( float3 )0;
			UNITY_BRANCH if ( _DDNA )
			{
				dynamicSwitch42 = UnpackScaleNormal( tex2D( _ddna, uv_ddna ), _NormalStrength );
			}
			else
			{
				dynamicSwitch42 = _DDNAColor.rgb;
			}
			float3 break3_g61447 = dynamicSwitch42;
			float3 appendResult6_g61447 = (float3(( break3_g61447.y * 1.0 ) , ( break3_g61447.x * -1.0 ) , break3_g61447.z));
			float3 ase_positionWS = i.worldPos;
			float3 temp_output_111_0_g61449 = ddx( ase_positionWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_113_0_g61449 = cross( ddy( ase_positionWS ) , ase_normalWS );
			float dotResult115_g61449 = dot( temp_output_111_0_g61449 , temp_output_113_0_g61449 );
			float temp_output_25_0_g61440 = _POMDisplacement;
			float2 uv_Disp = i.uv_texcoord * _Disp_ST.xy + _Disp_ST.zw;
			float4 dynamicSwitch41 = ( float4 )0;
			UNITY_BRANCH if ( _DISP )
			{
				dynamicSwitch41 = tex2D( _Disp, uv_Disp );
			}
			else
			{
				dynamicSwitch41 = float4( _DispColor.rgb , 0.0 );
			}
			float4 temp_output_33_0_g61440 = dynamicSwitch41;
			float temp_output_24_0_g61440 = _HeightBias;
			float2 uv_Blend = i.uv_texcoord * _Blend_ST.xy + _Blend_ST.zw;
			float4 dynamicSwitch35 = ( float4 )0;
			UNITY_BRANCH if ( _BLEND )
			{
				dynamicSwitch35 = tex2D( _Blend, uv_Blend );
			}
			else
			{
				dynamicSwitch35 = _BlendColor;
			}
			float temp_output_6_0_g61446 = dynamicSwitch35.r;
			float temp_output_2_0_g61446 = ( ( temp_output_6_0_g61446 + ( _BlendFactor / 255.0 ) ) * ( 0.5 / 255.0 ) );
			float blendFactor27_g61440 = saturate( temp_output_2_0_g61446 );
			float temp_output_20_0_g61449 = (  (0.0 + ( temp_output_33_0_g61440.r - 0.0 ) * ( 1.0 - 0.0 ) / ( temp_output_24_0_g61440 - 0.0 ) ) * blendFactor27_g61440 );
			float3 normalizeResult130_g61449 = normalize( ( ( abs( dotResult115_g61449 ) * ase_normalWS ) - ( temp_output_25_0_g61440 * float3( 0.05,0.05,0.05 ) * sign( dotResult115_g61449 ) * ( ( ddx( temp_output_20_0_g61449 ) * temp_output_113_0_g61449 ) + ( ddy( temp_output_20_0_g61449 ) * cross( ase_normalWS , temp_output_111_0_g61449 ) ) ) ) ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_tangentWS, ase_bitangentWS, ase_normalWS );
			float3 worldToTangentDir42_g61449 = mul( ase_worldToTangent, normalizeResult130_g61449 );
			o.Normal = BlendNormals( appendResult6_g61447 , worldToTangentDir42_g61449 );
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 dynamicSwitch38 = ( float4 )0;
			UNITY_BRANCH if ( _DIFFUSE )
			{
				dynamicSwitch38 = tex2D( _Diffuse, uv_Diffuse );
			}
			else
			{
				dynamicSwitch38 = _DiffuseColor;
			}
			float4 break30_g61440 = dynamicSwitch38;
			float3 appendResult31_g61440 = (float3(break30_g61440.r , break30_g61440.g , break30_g61440.b));
			float4 blendOpSrc61_g61440 = _BaseColor;
			float4 blendOpDest61_g61440 = float4( appendResult31_g61440 , 0.0 );
			float4 baseDiffuseMix32_g61440 = saturate( ( saturate( ( blendOpSrc61_g61440 * blendOpDest61_g61440 ) )) );
			float clampResult8_g61445 = clamp( blendFactor27_g61440 , 0.0 , 1.0 );
			float4 lerpResult1_g61445 = lerp( baseDiffuseMix32_g61440 , _BlendLayer2DiffuseColor , clampResult8_g61445);
			float4 clampResult14_g61445 = clamp( lerpResult1_g61445 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float2 uv_Decal = i.uv_texcoord * _Decal_ST.xy + _Decal_ST.zw;
			float4 dynamicSwitch37 = ( float4 )0;
			UNITY_BRANCH if ( _DECAL )
			{
				dynamicSwitch37 = tex2D( _Decal, uv_Decal );
			}
			else
			{
				dynamicSwitch37 = _DecalColor;
			}
			float4 temp_output_49_0_g61440 = dynamicSwitch37;
			float4 break50_g61440 = temp_output_49_0_g61440;
			float3 appendResult51_g61440 = (float3(break50_g61440.r , break50_g61440.g , break50_g61440.b));
			float4 lerpResult81_g61440 = lerp( clampResult14_g61445 , float4( appendResult51_g61440 , 0.0 ) , break50_g61440.a);
			o.Albedo = lerpResult81_g61440.rgb;
			float4 clampResult16_g61443 = clamp( i.vertexColor , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 blendOpSrc82_g61440 = clampResult16_g61443;
			float4 blendOpDest82_g61440 = temp_output_49_0_g61440;
			float diffuseAlpha7_g61440 = break30_g61440.a;
			o.Emission = ( ( saturate( ( blendOpSrc82_g61440 * blendOpDest82_g61440 ) )) * ( _Glow * diffuseAlpha7_g61440 ) ).rgb;
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			float4 dynamicSwitch40 = ( float4 )0;
			UNITY_BRANCH if ( _SPECULAR )
			{
				dynamicSwitch40 = tex2D( _Specular, uv_Specular );
			}
			else
			{
				dynamicSwitch40 = _SpecularColor;
			}
			float4 lerpResult9_g61445 = lerp( dynamicSwitch40 , _BlendLayer2SpecularColor , clampResult8_g61445);
			float4 clampResult15_g61445 = clamp( lerpResult9_g61445 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float3 linearToGamma130_g61440 = LinearToGammaSpace( clampResult15_g61445.rgb );
			o.Specular = linearToGamma130_g61440;
			float4 break4_g61420 = _DetailColor;
			float4 appendResult7_g61420 = (float4(break4_g61420.g , break4_g61420.a , break4_g61420.r , break4_g61420.b));
			float2 uv_Detail = i.uv_texcoord * _Detail_ST.xy + _Detail_ST.zw;
			float2 temp_output_1_0_g61420 = uv_Detail;
			float3 tex2DNode5_g61420 = UnpackScaleNormal( tex2D( _Detail, temp_output_1_0_g61420 ), _NormalStrength );
			float4 tex2DNode6_g61420 = tex2D( _Detail, temp_output_1_0_g61420 );
			float4 appendResult8_g61420 = (float4(tex2DNode5_g61420.r , tex2DNode5_g61420.g , tex2DNode6_g61420.b , tex2DNode6_g61420.a));
			float4 dynamicSwitch18 = ( float4 )0;
			UNITY_BRANCH if ( _DETAIL )
			{
				dynamicSwitch18 = appendResult8_g61420;
			}
			else
			{
				dynamicSwitch18 = appendResult7_g61420;
			}
			float4 break42_g61444 = dynamicSwitch18;
			float2 uv_DDNAGlossmap = i.uv_texcoord * _DDNAGlossmap_ST.xy + _DDNAGlossmap_ST.zw;
			float dynamicSwitch39 = ( float )0;
			UNITY_BRANCH if ( _DDNAGLOSSMAP )
			{
				dynamicSwitch39 = tex2D( _DDNAGlossmap, uv_DDNAGlossmap ).r;
			}
			else
			{
				dynamicSwitch39 = _DDNAColor.a;
			}
			float lerpResult10_g61445 = lerp( dynamicSwitch39 , ( ( _BlendLayer2Glossiness * 255.0 ) / 255.0 ) , clampResult8_g61445);
			float clampResult16_g61445 = clamp( lerpResult10_g61445 , 0.0 , 1.0 );
			float blendOpSrc80_g61440 = break42_g61444.w;
			float blendOpDest80_g61440 = clampResult16_g61445;
			float lerpBlendMode80_g61440 = lerp(blendOpDest80_g61440,( blendOpSrc80_g61440 * blendOpDest80_g61440 ),0.5);
			float temp_output_80_0_g61440 = ( saturate( lerpBlendMode80_g61440 ));
			o.Smoothness = temp_output_80_0_g61440;
			float lerpResult18_g61440 = lerp( 1.0 , diffuseAlpha7_g61440 , saturate( _UseAlpha ));
			o.Alpha = saturate( lerpResult18_g61440 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

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
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-2016,-1312;Inherit;True;Property;_Detail;Detail;14;0;Create;True;0;0;0;False;0;False;None;7a7db100f958b3048907436e6b41a6c4;True;white;Auto;Texture2D;True;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-1824,-1520;Inherit;False;Property;_DetailColor;Detail Color;13;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-1760,-1312;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-2096,-1056;Inherit;False;Property;_NormalStrength;Normal Strength;25;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-1472,-1280;Inherit;False;SC Detail Switcher;-1;;61420;f85975c798f86b44d915975c0d6aff4a;0;4;1;FLOAT2;1,1;False;2;SAMPLER2D;0;False;3;COLOR;0,0,0,0;False;9;FLOAT;1;False;2;COLOR;0;FLOAT4;10
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-1760,16;Inherit;True;Property;_Specular;Specular;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-1600,560;Inherit;True;Property;_Decal;Decal;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-1440,-272;Inherit;True;Property;_DDNAGlossmap;DDNA Glossmap;8;0;Create;True;0;0;0;False;0;False;-1;None;7984d43d943dd7a48b434475dfe3f8d6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-1120,-1280;Inherit;False;Property;_DetailTexture;Detail Texture;1;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DETAIL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-1520,-992;Inherit;True;Property;_Diffuse;Diffuse;5;1;[Gamma];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-1760,272;Inherit;True;Property;_Disp;Disp;12;0;Create;True;0;0;0;False;0;False;-1;None;dc73197aa6fc27b489a32b0858bd20f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-1968,208;Inherit;False;Property;_DispColor;Disp Color;11;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;21;-1440,-544;Inherit;True;Property;_ddna;ddna;7;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;880a6a94da38a1a44b0c323f221f2893;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-1696,-496;Inherit;False;Property;_DDNAColor;DDNA Color;6;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,0.9686275;0.5,0.5,1,0.9686275;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-1744,-176;Inherit;False;Property;_SpecularColor;Specular Color;9;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0.5,0.5,0.5,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-1840,496;Inherit;False;Property;_DecalColor;Decal Color;15;0;Create;True;0;0;0;False;0;False;0.9490196,0.5568628,0.2117647,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-1488,768;Inherit;True;Property;_Blend;Blend;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;True;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-1792,736;Inherit;False;Property;_BlendColor;Blend Color;18;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-1488,-1136;Inherit;False;Property;_DiffuseColor;Diffuse Color;4;1;[Gamma];Create;True;0;0;0;False;0;False;0,0,0,0.01960784;0.737255,0.737255,0.737255,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-1472,960;Inherit;False;Property;_BlendLayer2DiffuseColor;Blend Layer 2 Diffuse Color;19;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4627451,0.4627451,0.4627451,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-1472,1152;Inherit;False;Property;_BlendFactor;Blend Factor;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;-1440,1840;Inherit;False;Property;_UseAlpha;Use Alpha;26;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-1472,2000;Inherit;False;Property;_POMDisplacement;POM Displacement;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;-1456,1520;Inherit;False;Property;_BlendLayer2Glossiness;Blend Layer 2 Glossiness;21;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-1488,1312;Inherit;False;Property;_BlendLayer2SpecularColor;Blend Layer 2 Specular Color;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.737255,0.737255,0.737255,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-912,-1280;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-1184,496;Inherit;False;Property;_DecalTexture1;Decal Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DECAL;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;-1248,-1040;Inherit;False;Property;_SpecularTexture;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DIFFUSE;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1040,-336;Inherit;False;Property;_GlossmapTexture;Glossmap Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNAGLOSSMAP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1424,-48;Inherit;False;Property;_SpecularTexture1;Specular Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_SPECULAR;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1392,208;Inherit;False;Property;_DispTexture;Disp Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DISP;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-1040,-496;Inherit;False;Property;_DDNATexture;DDNA Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_DDNA;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;-1456,1232;Inherit;False;Constant;_BlendFalloff;Blend Falloff;24;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-1472,1920;Inherit;False;Property;_HeightBias;Height Bias;27;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-1424,1680;Inherit;False;Property;_Glow;Glow;24;0;Create;True;0;0;0;False;0;False;64;64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-1120,736;Inherit;False;Property;_DecalTexture;Blend Texture;26;0;Create;True;0;0;0;False;0;False;2;1;1;False;_BLEND;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-1456,-800;Inherit;False;Property;_BaseColor;Base Color;3;1;[Gamma];Create;True;0;0;0;False;0;False;0,0,0,0.2;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-1456,2080;Inherit;False;Property;_DetailDiffuseScale;Detail Diffuse Scale;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-1456,2160;Inherit;False;Property;_DetailGlossScale;Detail Gloss Scale;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-1136,656;Inherit;False;Property;_MetalTweak;Metal Tweak;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-480,0;Inherit;False;SC Display Screen;0;;61440;3bfde0c2eb2a9e04484ada6dab455659;1,39,0;70;62;COLOR;0,0,0,1;False;63;COLOR;0,0,0,0;False;66;FLOAT3;0,0,0;False;65;FLOAT;0;False;9;COLOR;0,0,0,0;False;33;COLOR;0,0,0,0;False;37;COLOR;0,0,0,0;False;49;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;36;COLOR;0,0,0,0;False;35;COLOR;0,0,0,0;False;34;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0.5;False;15;COLOR;0,0,0,0;False;16;COLOR;0,0,0,0;False;48;FLOAT;0;False;13;FLOAT;0;False;14;FLOAT;0;False;44;FLOAT;0;False;20;FLOAT;0;False;24;FLOAT;0;False;25;FLOAT;0;False;127;COLOR;0,0,0,0;False;105;FLOAT;0;False;86;COLOR;0,0,0,0;False;107;FLOAT;0;False;108;FLOAT;0;False;109;FLOAT;0;False;93;FLOAT;0;False;110;FLOAT;0;False;112;FLOAT;0;False;106;FLOAT;0;False;99;FLOAT;0;False;115;COLOR;0,0,0,0;False;101;FLOAT;0;False;100;FLOAT;0;False;88;FLOAT;0;False;104;FLOAT;0;False;123;FLOAT;0;False;124;FLOAT;0;False;125;COLOR;0,0,0,0;False;126;COLOR;0,0,0,0;False;114;FLOAT;0;False;103;FLOAT;0;False;98;FLOAT;0;False;94;FLOAT;0;False;90;FLOAT;0;False;116;FLOAT;0;False;113;FLOAT;0;False;95;FLOAT;0;False;85;COLOR;0,0,0,0;False;84;COLOR;0,0,0,0;False;83;COLOR;0,0,0,0;False;17;COLOR;0,0,0,0;False;91;FLOAT;0;False;97;FLOAT;0;False;96;FLOAT;0;False;128;COLOR;0,0,0,0;False;117;FLOAT;0;False;118;FLOAT;0;False;119;FLOAT;0;False;120;FLOAT;0;False;121;FLOAT;0;False;122;FLOAT;0;False;87;COLOR;0,0,0,0;False;92;FLOAT;0;False;111;FLOAT;0;False;102;FLOAT;0;False;129;COLOR;0,0,0,0;False;7;COLOR;72;FLOAT3;68;COLOR;71;FLOAT3;73;FLOAT;70;FLOAT;67;COLOR;69
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;0,0;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;Star Citizen/Display Screen;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;True;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;0;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;2;3;0
WireConnection;7;1;6;0
WireConnection;7;2;3;0
WireConnection;7;3;5;0
WireConnection;7;9;4;0
WireConnection;18;1;7;0
WireConnection;18;0;7;10
WireConnection;21;5;4;0
WireConnection;36;0;18;0
WireConnection;37;1;15;0
WireConnection;37;0;16;0
WireConnection;38;1;19;0
WireConnection;38;0;20;0
WireConnection;39;1;8;4
WireConnection;39;0;17;1
WireConnection;40;1;9;0
WireConnection;40;0;10;0
WireConnection;41;1;11;5
WireConnection;41;0;12;0
WireConnection;42;1;8;5
WireConnection;42;0;21;0
WireConnection;35;1;13;0
WireConnection;35;0;14;0
WireConnection;50;62;34;0
WireConnection;50;63;38;0
WireConnection;50;66;42;0
WireConnection;50;65;39;0
WireConnection;50;9;40;0
WireConnection;50;33;41;0
WireConnection;50;37;36;0
WireConnection;50;49;37;0
WireConnection;50;3;35;0
WireConnection;50;36;22;0
WireConnection;50;35;32;0
WireConnection;50;34;31;0
WireConnection;50;4;24;0
WireConnection;50;5;23;0
WireConnection;50;44;27;0
WireConnection;50;20;28;0
WireConnection;50;24;29;0
WireConnection;50;25;30;0
WireConnection;0;0;50;72
WireConnection;0;1;50;68
WireConnection;0;2;50;71
WireConnection;0;3;50;73
WireConnection;0;4;50;70
WireConnection;0;9;50;67
ASEEND*/
//CHKSM=B23A2BD2D4ED27F345A0A50526ED8C9CC8C05C3B