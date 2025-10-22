// Made with Amplify Shader Editor v1.9.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Star Citizen/Illum.Emit"
{
	Properties
	{
		_BaseColor( "Base Color", Color ) = ( 1, 1, 1, 1 )
		_Diffuse( "Diffuse", 2D ) = "white" {}
		_Temperature( "Temperature", Float ) = 0
		_Glow( "Glow", Float ) = 0.1
		_GeomLink( "Geom Link", Float ) = 0
		_SpecularColor( "Specular Color", Color ) = ( 0, 0, 0, 0 )
		_LightLink( "Light Link", Color ) = ( 0, 0, 0, 1 )
		_EmissionMultiplier( "Emission Multiplier", Float ) = 1
		_Emission( "_Emission", Color ) = ( 0, 0, 0, 0 )
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardBRDF.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#define ASE_VERSION 19904
		#pragma surface surf Unlit alpha:fade keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 ase_positionRWS;
		};

		uniform float4 _Emission;
		uniform float4 _SpecularColor;
		uniform float _Temperature;
		uniform float4 _LightLink;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _BaseColor;
		uniform float _GeomLink;
		uniform float _Glow;
		uniform float _EmissionMultiplier;


		float3 Blackbody1_g2( float Temperature )
		{
			float3 color = float3(255.0, 255.0, 255.0);
			color.x = 56100000. * pow(Temperature,(-3.0 / 2.0)) + 148.0;
			color.y = 100.04 * log(Temperature) - 623.6;
			if (Temperature > 6500.0) color.y = 35200000.0 * pow(Temperature,(-3.0 / 2.0)) + 184.0;
			color.z = 194.18 * log(Temperature) - 1448.6;
			color = clamp(color, 0.0, 255.0)/255.0;
			if (Temperature < 1000.0) color *= Temperature/1000.0;
			return color;
		}


		float4x4 InverseProjectionMatrix()
		{
			float4x4 m = UNITY_MATRIX_P;
			float n11 = m[ 0 ][ 0 ];
			float n22 = m[ 1 ][ 1 ];
			float n33 = m[ 2 ][ 2 ];
			float n34 = m[ 3 ][ 2 ];
			float n43 = m[ 2 ][ 3 ];
			float t11 = -n22 * n34 * n43;
			float det = n11 * t11;
			float idet = 1.0f / det;
			m[ 0 ][ 0 ] = +t11* idet;
			m[ 1 ][ 1 ] = -n11* n34 * n43* idet;
			m[ 2 ][ 2 ] = 0;
			m[ 2 ][ 3 ] = -n11* n22 * n43* idet;
			m[ 3 ][ 2 ] = -n11* n22 * n34* idet;
			m[ 3 ][ 3 ] = +n11* n22 * n33* idet;
			return m;
		}


		float3 ASESafeNormalize(float3 inVec)
		{
			float dp3 = max(1.175494351e-38, dot(inVec, inVec));
			return inVec* rsqrt(dp3);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_positionOS4f = v.vertex;
			float4x4 ase_matrixInvP = InverseProjectionMatrix();
			float4 ase_positionCS = UnityObjectToClipPos( ase_positionOS4f );
			float4 ase_hpositionVS = mul( ase_matrixInvP, ase_positionCS );
			float3 ase_positionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, ase_hpositionVS.xyz / ase_hpositionVS.w );
			o.ase_positionRWS = ase_positionRWS;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float Temperature1_g2 = _Temperature;
			float3 localBlackbody1_g2 = Blackbody1_g2( Temperature1_g2 );
			float3 temp_output_22_0 = localBlackbody1_g2;
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 tex2DNode1 = tex2D( _Diffuse, uv_Diffuse );
			float3 blendOpSrc11 = tex2DNode1.rgb;
			float3 blendOpDest11 = _BaseColor.rgb;
			float3 blendOpSrc24 = pow( _LightLink.rgb , 0.8 );
			float3 blendOpDest24 = ( saturate( ( blendOpSrc11 * blendOpDest11 ) ));
			float3 lerpBlendMode24 = lerp(blendOpDest24,( blendOpSrc24 * blendOpDest24 ),_GeomLink);
			float3 temp_output_24_0 = ( saturate( lerpBlendMode24 ));
			float3 blendOpSrc26 = temp_output_22_0;
			float3 blendOpDest26 = temp_output_24_0;
			float temp_output_23_0 = ( _Temperature > 1199.0 ? 1.0 : 0.0 );
			float3 lerpBlendMode26 = lerp(blendOpDest26,( blendOpSrc26 * blendOpDest26 ),temp_output_23_0);
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
			float3 ase_positionRWS = i.ase_positionRWS;
			float3 temp_output_102_0_g1 = ( cross( ddx( ase_positionRWS ) , ddy( ase_positionRWS ) ) * _ProjectionParams.x );
			float3 normalizeResult87_g1 = ASESafeNormalize( temp_output_102_0_g1 );
			float dotResult17 = dot( ase_viewDirSafeWS , normalizeResult87_g1 );
			o.Emission = ( ( saturate( lerpBlendMode26 )) * ( tex2DNode1.a * saturate( dotResult17 ) * _Glow * _EmissionMultiplier ) );
			o.Alpha = tex2DNode1.a;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19904
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;21;-800,-320;Inherit;False;Property;_LightLink;Light Link;9;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-1056,-576;Inherit;False;Property;_BaseColor;Base Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;-1120,-368;Inherit;True;Property;_Diffuse;Diffuse;1;0;Create;True;0;0;0;False;0;False;-1;None;bfe6ed58eb1ac4747be4b1bacf4372b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-1232,176;Inherit;True;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-1200,368;Inherit;False;Normal Face;-1;;1;f4725843c667a994e8a7e4987db394b2;2,88,0,86,1;0;1;FLOAT3;30
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-560,-32;Inherit;False;Property;_Temperature;Temperature;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-592,-272;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.8;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-816,-544;Inherit;True;Multiply;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-1056,-16;Inherit;False;Constant;_TemperatureThreshold;Temperature Threshold;10;0;Create;True;0;0;0;False;0;False;1199;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-992,176;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-736,-112;Inherit;False;Property;_GeomLink;Geom Link;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-352,-112;Inherit;False;Blackbody;-1;;2;e2cbc0474cd946f4ea11e89cfd2c903a;0;1;2;FLOAT;1000;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-416,-288;Inherit;True;Multiply;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Compare, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;-368,-32;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;1200;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-864,256;Inherit;False;Property;_Glow;Glow;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-864,176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-960,336;Inherit;False;Property;_EmissionMultiplier;Emission Multiplier;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-96,-144;Inherit;True;Multiply;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-656,176;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;1000;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-160,272;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-112,-240;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-1264,128;Inherit;False;791;340;Emission Strength;;1,1,1,1;;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-832,512;Inherit;False;Property;_DispColor;Disp Color;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-688,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;144,16;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;64,-352;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-672,912;Inherit;False;Property;_MetalTweak;Metal Tweak;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;-1316.031,-176.8513;Inherit;False;Constant;_DiffuseColor;Diffuse Color;11;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-672,512;Inherit;False;Property;_DDNAColor;DDNA Color;8;0;Create;True;0;0;0;False;0;False;0.5,0.5,1,0.9686275;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1340.536,482.3128;Inherit;False;Property;_Emission;_Emission;11;0;Create;True;0;0;0;True;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-672,720;Inherit;False;Property;_SpecularColor;Specular Color;7;0;Create;True;0;0;0;True;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;336,-32;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;Star Citizen/Illum.Emit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;21;5
WireConnection;11;0;1;5
WireConnection;11;1;2;5
WireConnection;17;0;16;0
WireConnection;17;1;18;30
WireConnection;22;2;5;0
WireConnection;24;0;25;0
WireConnection;24;1;11;0
WireConnection;24;2;7;0
WireConnection;23;0;5;0
WireConnection;23;1;36;0
WireConnection;19;0;17;0
WireConnection;26;0;22;0
WireConnection;26;1;24;0
WireConnection;26;2;23;0
WireConnection;12;0;1;4
WireConnection;12;1;19;0
WireConnection;12;2;6;0
WireConnection;12;3;37;0
WireConnection;35;0;22;0
WireConnection;30;0;24;0
WireConnection;30;1;22;0
WireConnection;27;0;1;4
WireConnection;29;0;26;0
WireConnection;29;1;12;0
WireConnection;32;0;24;0
WireConnection;32;1;30;0
WireConnection;32;2;23;0
WireConnection;0;2;29;0
WireConnection;0;9;27;0
ASEEND*/
//CHKSM=86F73D18F4F5D697D3EFED540FDE23BEE9082A99