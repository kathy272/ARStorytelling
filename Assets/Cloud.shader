// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cloud"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.08
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_CloudCutoff("Cloud Cutoff", Range( 0.1 , 1)) = 0.1
		_Softness("Softness", Range( 0.01 , 3)) = 0.4235503
		_midYValue("midYValue", Range( 0 , 5)) = 0.9
		_cloudHeight("cloudHeight", Range( 0 , 5)) = 2.95
		_TaperPower("Taper Power", Range( 0 , 5)) = 1.26
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Background+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 viewDir;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _midYValue;
		uniform float _cloudHeight;
		uniform float _TaperPower;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _TextureSample0;
		uniform float _CloudCutoff;
		uniform float _Softness;
		uniform float _Cutoff = 0.08;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult57 = dot( i.viewDir , -ase_worldlightDir );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			o.Albedo = ( pow( saturate( dotResult57 ) , 18.08696 ) * 0.85 * ase_lightColor ).rgb;
			float temp_output_46_0 = ( 1.0 - pow( saturate( ( abs( ( _midYValue - ase_worldPos.y ) ) / ( _cloudHeight * 0.34 ) ) ) , _TaperPower ) );
			float4 appendResult5 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float mulTime69 = _Time.y * 0.12;
			float4 appendResult9 = (float4(mulTime69 , 0.0 , 0.0 , 0.0));
			float temp_output_16_0 = ( tex2D( _TextureSample1, ( 0.66 * ( appendResult5 - appendResult9 ) * 0.1 ).xy ).r * tex2D( _TextureSample0, ( ( appendResult5 + appendResult9 ) * 1.32 * 0.1 ).xy ).r );
			float3 temp_cast_3 = (( 1.0 - ( temp_output_46_0 - ( temp_output_16_0 * temp_output_46_0 ) ) )).xxx;
			o.Emission = temp_cast_3;
			o.Alpha = 1;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV65 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode65 = ( 0.0 + 2.66 * pow( 1.0 - fresnelNdotV65, 2.66 ) );
			clip( pow( saturate( (0.0 + (( temp_output_16_0 * temp_output_46_0 * ( 1.0 - fresnelNode65 ) ) - 0.0) * (1.0 - 0.0) / (_CloudCutoff - 0.0)) ) , _Softness ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
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
				float3 worldNormal : TEXCOORD2;
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
				o.worldNormal = worldNormal;
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
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
Node;AmplifyShaderEditor.RangedFloatNode;70;-992,-128;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-544,416;Float;False;Property;_midYValue;midYValue;6;0;Create;True;0;0;0;False;0;False;0.9;2.38;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-480,512;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-816,-400;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;69;-800.2252,-127.0822;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-131.657,473.4375;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-112,592;Float;False;Property;_cloudHeight;cloudHeight;7;0;Create;True;0;0;0;False;0;False;2.95;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;176,704;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;0.34;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-544,-384;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-592,-192;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;192.3457,584.1104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;32;112,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-256,-176;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-288,16;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;0;False;0;False;1.32;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;336,448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;176,-272;Inherit;False;Constant;_Float3;Float 3;9;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-288,-384;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;12;32,-496;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.66;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-32,-128;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;67;224,64;Inherit;False;Constant;_Float6;Float 6;9;0;Create;True;0;0;0;False;0;False;2.66;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;176,176;Inherit;False;Constant;_Float7;Float 6;9;0;Create;True;0;0;0;False;0;False;2.66;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;576,544;Inherit;False;Property;_TaperPower;Taper Power;8;0;Create;True;0;0;0;False;0;False;1.26;3.56;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;525.3457,428.1104;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;240,-512;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;6;480,-192;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;6;7f707e9b76cdb7c4a8c3b05bef6d7f27;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FresnelNode;65;448,32;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;752,320;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;55;-336,-1344;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;15;480,-608;Inherit;True;Property;_TextureSample1;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;6;7f707e9b76cdb7c4a8c3b05bef6d7f27;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;848,-528;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;66;688,48;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;46;928,320;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;54;-312.6884,-1505.507;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;56;-39.36584,-1383.664;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;1056,-768;Inherit;False;Property;_CloudCutoff;Cloud Cutoff;3;0;Create;True;0;0;0;False;0;False;0.1;0.88;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1152,-512;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;57;144,-1504;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;19;1440,-640;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1312,320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;58;352,-1536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;272,-1392;Inherit;False;Constant;_SSSPower;SSS Power;10;0;Create;True;0;0;0;False;0;False;18.08696;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;1648,-560;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;1600,-768;Inherit;False;Property;_Softness;Softness;4;0;Create;True;0;0;0;False;0;False;0.4235503;3;0.01;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;1504,464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;59;560,-1504;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;656,-1408;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;0.85;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;63;1152,-1408;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;22;1936,-560;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;1936.355,402.707;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;1680,144;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1872,-880;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;-128,-720;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;9ac0a7ba6bf510e4ba3e9af1dad077e2;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;25;2256,-512;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Cloud;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.08;True;True;0;True;Transparent;;Background;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;69;0;70;0
WireConnection;30;0;29;0
WireConnection;30;1;31;2
WireConnection;5;0;4;1
WireConnection;5;1;4;3
WireConnection;9;0;69;0
WireConnection;34;0;35;0
WireConnection;34;1;53;0
WireConnection;32;0;30;0
WireConnection;40;0;5;0
WireConnection;40;1;9;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;13;0;5;0
WireConnection;13;1;9;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;41;2;43;0
WireConnection;36;0;33;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;14;2;43;0
WireConnection;6;1;41;0
WireConnection;65;2;67;0
WireConnection;65;3;68;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;15;1;14;0
WireConnection;16;0;15;1
WireConnection;16;1;6;1
WireConnection;66;0;65;0
WireConnection;46;0;37;0
WireConnection;56;0;55;0
WireConnection;39;0;16;0
WireConnection;39;1;46;0
WireConnection;39;2;66;0
WireConnection;57;0;54;0
WireConnection;57;1;56;0
WireConnection;19;0;39;0
WireConnection;19;2;18;0
WireConnection;47;0;16;0
WireConnection;47;1;46;0
WireConnection;58;0;57;0
WireConnection;20;0;19;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;49;0;48;0
WireConnection;61;0;59;0
WireConnection;61;1;62;0
WireConnection;61;2;63;0
WireConnection;25;0;61;0
WireConnection;25;2;49;0
WireConnection;25;10;22;0
ASEEND*/
//CHKSM=24CE9283D775FF7989A86AF63C09DA91E2ECAA79