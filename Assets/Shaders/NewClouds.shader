// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NewClouds"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.86
		_CloudCutoff("Cloud Cutoff", Range( 0.1 , 1)) = 0.9825232
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_Softness("Softness", Range( 0.01 , 3)) = 0.5387885
		_midYValue("midYValue", Range( 0 , 5)) = 0.9
		_cloudHeight("cloudHeight", Range( 0 , 5)) = 2.95
		_TaperPower("Taper Power", Range( 0 , 5)) = 0.4270561
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
		};

		uniform float _midYValue;
		uniform float _cloudHeight;
		uniform float _TaperPower;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _TextureSample1;
		uniform float _CloudCutoff;
		uniform float _Softness;
		uniform float _Cutoff = 0.86;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_27_0 = ( 1.0 - pow( saturate( ( abs( ( _midYValue - ase_worldPos.y ) ) / ( _cloudHeight * 0.97 ) ) ) , _TaperPower ) );
			float4 appendResult9 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float mulTime8 = _Time.y * 0.02;
			float4 temp_cast_1 = (mulTime8).xxxx;
			float temp_output_28_0 = ( tex2D( _TextureSample0, ( 0.34 * ( appendResult9 + mulTime8 ) ).xy ).r * tex2D( _TextureSample1, ( 0.44 * ( appendResult9 - temp_cast_1 ) * 0.34 ).xy ).r );
			float3 temp_cast_3 = (( 1.0 - ( temp_output_27_0 - ( temp_output_28_0 * temp_output_27_0 ) ) )).xxx;
			o.Emission = temp_cast_3;
			o.Alpha = 1;
			float4 temp_cast_5 = (mulTime8).xxxx;
			clip( pow( saturate( (0.0 + (( temp_output_28_0 * temp_output_27_0 ) - 0.0) * (1.0 - 0.0) / (_CloudCutoff - 0.0)) ) , _Softness ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float3 worldPos : TEXCOORD1;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19603
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-2358.343,1234.863;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;2;-2380.685,1103.884;Float;False;Property;_midYValue;midYValue;5;0;Create;True;0;0;0;False;0;False;0.9;2.02;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1772.685,63.88391;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1548.685,415.8839;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-2010,1196.3;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1702.343,1426.863;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;0.97;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2012.685,1359.884;Float;False;Property;_cloudHeight;cloudHeight;6;0;Create;True;0;0;0;False;0;False;2.95;3.18;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-1292.685,223.8839;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1836.685,-144.1161;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1685.997,1306.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;11;-1766.343,1170.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1452.685,-192.1161;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1516.685,-384.1161;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.34;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1170.301,-581.4291;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-850.3014,-693.4291;Inherit;False;Constant;_Float8;Float 0;1;0;Create;True;0;0;0;False;0;False;0.44;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-1542.343,1170.863;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1228.685,-336.1161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-642.3014,-709.4291;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;19;-1352.997,1150.973;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1308.685,1279.884;Inherit;False;Property;_TaperPower;Taper Power;8;0;Create;True;0;0;0;False;0;False;0.4270561;1.66;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-402.3014,-805.4291;Inherit;True;Property;_TextureSample1;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;7f707e9b76cdb7c4a8c3b05bef6d7f27;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;23;-924.6851,-192.1161;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;9ac0a7ba6bf510e4ba3e9af1dad077e2;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode;24;-1126.343,1042.863;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-950.3431,1042.863;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-732.6851,95.88391;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-572.6851,-368.1161;Inherit;False;Property;_CloudCutoff;Cloud Cutoff;2;0;Create;True;0;0;0;False;0;False;0.9825232;0.1046225;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-332.6851,-48.11609;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;-276.1556,-226.9638;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-332.6851,783.8839;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;-12.68506,-208.1161;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-140.6851,-464.1161;Inherit;False;Property;_Softness;Softness;4;0;Create;True;0;0;0;False;0;False;0.5387885;2.58;0.01;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;-12.68506,975.8839;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;21;-1610.595,-1273.381;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;25;-1587.283,-1434.888;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;26;-1313.961,-1313.045;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;29;-1130.595,-1433.381;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-922.5948,-1465.381;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1002.595,-1321.381;Inherit;False;Constant;_SSSPower;SSS Power;10;0;Create;True;0;0;0;False;0;False;35.22457;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;-714.5948,-1433.381;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-668.6851,-1280.116;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;2.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;39;115.3149,-864.1161;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;42;-1052.685,335.8839;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;43;-796.6851,351.8839;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;275.3149,639.8839;Inherit;False;Constant;_Float9;Float 6;9;0;Create;True;0;0;0;False;0;False;0.21;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;323.3149,527.8839;Inherit;False;Constant;_Float10;Float 6;9;0;Create;True;0;0;0;False;0;False;1.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;46;547.3149,495.8839;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;219.8444,-146.9638;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;467.3149,-432.1161;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1660.685,-304.1161;Inherit;False;Constant;_Float2;Float 0;1;0;Create;True;0;0;0;False;0;False;0.93;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;-1010.301,-917.4291;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;9ac0a7ba6bf510e4ba3e9af1dad077e2;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;51;531.3149,-288.1161;Inherit;False;Constant;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;1,1,1,0.2039216;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;52;883.3149,399.8839;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;-1068.685,95.88391;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;387.3149,271.8839;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;880,-176;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;NewClouds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.86;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;2;0
WireConnection;5;1;1;2
WireConnection;8;0;4;0
WireConnection;9;0;3;1
WireConnection;9;1;3;3
WireConnection;10;0;7;0
WireConnection;10;1;6;0
WireConnection;11;0;5;0
WireConnection;12;0;9;0
WireConnection;12;1;8;0
WireConnection;14;0;9;0
WireConnection;14;1;8;0
WireConnection;16;0;11;0
WireConnection;16;1;10;0
WireConnection;17;0;13;0
WireConnection;17;1;12;0
WireConnection;18;0;15;0
WireConnection;18;1;14;0
WireConnection;18;2;13;0
WireConnection;19;0;16;0
WireConnection;22;1;18;0
WireConnection;23;1;17;0
WireConnection;24;0;19;0
WireConnection;24;1;20;0
WireConnection;27;0;24;0
WireConnection;28;0;23;1
WireConnection;28;1;22;1
WireConnection;31;0;28;0
WireConnection;31;1;27;0
WireConnection;32;0;31;0
WireConnection;32;2;30;0
WireConnection;35;0;28;0
WireConnection;35;1;27;0
WireConnection;36;0;32;0
WireConnection;41;0;27;0
WireConnection;41;1;35;0
WireConnection;26;0;21;0
WireConnection;29;0;25;0
WireConnection;29;1;26;0
WireConnection;33;0;29;0
WireConnection;37;0;33;0
WireConnection;37;1;34;0
WireConnection;43;0;42;2
WireConnection;46;2;45;0
WireConnection;46;3;44;0
WireConnection;47;0;36;0
WireConnection;47;1;40;0
WireConnection;48;0;37;0
WireConnection;48;1;38;0
WireConnection;48;2;39;0
WireConnection;52;0;46;0
WireConnection;53;0;41;0
WireConnection;0;2;53;0
WireConnection;0;10;47;0
ASEEND*/
//CHKSM=BDFD3FFC7501A03A338C230D2A81A265B7047B0D