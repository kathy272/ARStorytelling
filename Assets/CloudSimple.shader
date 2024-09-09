// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CloudSimple"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.04
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_CloudCutoff("Cloud Cutoff", Range( 0.1 , 1)) = 0.9202897
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_Softness("Softness", Range( 0.01 , 3)) = 3
		_midYValue("midYValue", Range( -3 , 5)) = -1.053197
		_cloudHeight("cloudHeight", Range( -3 , 5)) = 2.95
		_TaperPower("Taper Power", Range( -3 , 5)) = 2.861839
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers playstation ps4 ps5 switch 
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred 
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
		uniform float _Cutoff = 0.04;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_34_0 = ( 1.0 - pow( saturate( ( abs( ( _midYValue - ase_worldPos.y ) ) / ( _cloudHeight * 0.28 ) ) ) , _TaperPower ) );
			float4 appendResult5 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float mulTime2 = _Time.y * 0.03;
			float4 temp_cast_1 = (mulTime2).xxxx;
			float temp_output_57_0 = ( tex2D( _TextureSample0, ( 0.5 * ( appendResult5 + mulTime2 ) ).xy ).r * tex2D( _TextureSample1, ( 0.63 * ( appendResult5 - temp_cast_1 ) * 0.5 ).xy ).r );
			float3 temp_cast_3 = (( 1.0 - ( temp_output_34_0 - ( temp_output_57_0 * temp_output_34_0 ) ) )).xxx;
			o.Emission = temp_cast_3;
			o.Alpha = 1;
			float4 temp_cast_5 = (mulTime2).xxxx;
			clip( pow( saturate( (0.0 + (( temp_output_57_0 * temp_output_34_0 ) - 0.0) * (1.0 - 0.0) / (_CloudCutoff - 0.0)) ) , _Softness ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19603
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1993.658,834.9788;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;23;-2016,704;Float;False;Property;_midYValue;midYValue;5;0;Create;True;0;0;0;False;0;False;-1.053197;0;-3;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-1408,-336;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1645.315,796.4163;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1337.658,1026.979;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;0.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1648,960;Float;False;Property;_cloudHeight;cloudHeight;6;0;Create;True;0;0;0;False;0;False;2.95;0.6;-3;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1168,16;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-928,-176;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-1472,-544;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1321.312,907.0892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;29;-1401.658,770.9788;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1088,-592;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-805.6163,-981.313;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-1177.658,770.9788;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1152,-784;Inherit;False;Constant;_Frequency;Frequency;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-544,-1120;Inherit;False;Constant;_Float8;Float 0;1;0;Create;True;0;0;0;False;0;False;0.63;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-864,-736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-277.6163,-1109.313;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;32;-988.3123,751.0892;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-944,880;Inherit;False;Property;_TaperPower;Taper Power;8;0;Create;True;0;0;0;False;0;False;2.861839;0;-3;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-37.61633,-1205.313;Inherit;True;Property;_TextureSample1;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;7f707e9b76cdb7c4a8c3b05bef6d7f27;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode;33;-761.658,642.9788;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-560,-592;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;9ac0a7ba6bf510e4ba3e9af1dad077e2;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;34;-585.658,642.9788;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-368,-304;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;32,-448;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-128,-784;Inherit;False;Property;_CloudCutoff;Cloud Cutoff;2;0;Create;True;0;0;0;False;0;False;0.9202897;0.237;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;88.52942,-626.8477;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;32,384;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;352,-608;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;272,-848;Inherit;False;Property;_Softness;Softness;4;0;Create;True;0;0;0;False;0;False;3;1.62;0.01;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;352,576;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;39;-1245.91,-1673.265;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;40;-1222.598,-1834.772;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;41;-949.2756,-1712.929;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;42;-765.9098,-1833.265;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;43;-557.9098,-1865.265;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-637.9098,-1721.265;Inherit;False;Constant;_SSSPower;SSS Power;10;0;Create;True;0;0;0;False;0;False;35.22457;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;45;-349.9098,-1833.265;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-304,-1680;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;2.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;47;480,-1264;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;64;-688,-64;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;20;-432,-48;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;640,240;Inherit;False;Constant;_Float9;Float 6;9;0;Create;True;0;0;0;False;0;False;0.21;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;688,128;Inherit;False;Constant;_Float10;Float 6;9;0;Create;True;0;0;0;False;0;False;1.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;62;912,96;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;584.5294,-546.8477;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;-645.6163,-1317.313;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;9ac0a7ba6bf510e4ba3e9af1dad077e2;7f707e9b76cdb7c4a8c3b05bef6d7f27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;63;1248,0;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;752,-128;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-704,-304;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;834,-832;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;59;1010,-864;Inherit;False;Constant;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;1,1,1,0.2039216;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1344,-656;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CloudSimple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.04;True;False;0;True;TransparentCutout;;Geometry;ForwardOnly;8;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;xboxseries;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;23;0
WireConnection;25;1;24;2
WireConnection;2;0;3;0
WireConnection;5;0;4;1
WireConnection;5;1;4;3
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;29;0;25;0
WireConnection;15;0;5;0
WireConnection;15;1;2;0
WireConnection;52;0;5;0
WireConnection;52;1;2;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;6;0;7;0
WireConnection;6;1;15;0
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;54;2;7;0
WireConnection;32;0;30;0
WireConnection;55;1;54;0
WireConnection;33;0;32;0
WireConnection;33;1;31;0
WireConnection;1;1;6;0
WireConnection;34;0;33;0
WireConnection;57;0;1;1
WireConnection;57;1;55;1
WireConnection;22;0;57;0
WireConnection;22;1;34;0
WireConnection;10;0;22;0
WireConnection;10;2;8;0
WireConnection;36;0;57;0
WireConnection;36;1;34;0
WireConnection;11;0;10;0
WireConnection;37;0;34;0
WireConnection;37;1;36;0
WireConnection;41;0;39;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;43;0;42;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;20;0;64;2
WireConnection;62;2;61;0
WireConnection;62;3;60;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;63;0;62;0
WireConnection;38;0;37;0
WireConnection;48;0;45;0
WireConnection;48;1;46;0
WireConnection;48;2;47;0
WireConnection;0;2;38;0
WireConnection;0;10;13;0
ASEEND*/
//CHKSM=7FFD057BFB853014A927174D5D510363CE421C3F