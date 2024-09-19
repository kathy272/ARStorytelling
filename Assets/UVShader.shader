// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UVShader"
{
	Properties
	{
		_StyleHeightmap("StyleHeightmap", 2D) = "white" {}
		_BumpPower("BumpPower", Float) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_TextureSample4("Texture Sample 3", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_DisplacementScale("DisplacementScale", Float) = 1.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample4;
		uniform float4 _TextureSample4_ST;
		uniform float _BumpPower;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float _DisplacementScale;
		uniform sampler2D _TextureSample3;
		uniform float4 _TextureSample3_ST;
		uniform sampler2D _StyleHeightmap;
		uniform float4 _StyleHeightmap_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TextureSample4 = v.texcoord * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
			float4 tex2DNode76 = tex2Dlod( _TextureSample4, float4( uv_TextureSample4, 0, 0.0) );
			float dotResult77 = dot( tex2DNode76.rgb , tex2DNode76.rgb );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_TextureSample2 = v.texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( ( ( dotResult77 * _BumpPower ) * ase_vertexNormal ) + ( ( tex2Dlod( _TextureSample2, float4( uv_TextureSample2, 0, 0.0) ).rgb * _DisplacementScale ) + ase_vertex3Pos ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample3 = i.uv_texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			float4 tex2DNode4 = tex2D( _TextureSample3, uv_TextureSample3 );
			float2 uv_StyleHeightmap = i.uv_texcoord * _StyleHeightmap_ST.xy + _StyleHeightmap_ST.zw;
			float4 tex2DNode9 = tex2D( _StyleHeightmap, uv_StyleHeightmap );
			float smoothstepResult22 = smoothstep( 0.0 , 1.0 , 2.55);
			float4 temp_cast_0 = (smoothstepResult22).xxxx;
			float dotResult23 = dot( tex2DNode9.rgb , float3(1,0.82,-1.22) );
			float4 lerpResult26 = lerp( tex2DNode9 , temp_cast_0 , dotResult23);
			float4 lerpResult28 = lerp( lerpResult26 , float4( 0,0,0,0 ) , float4( 0,0,0,0 ));
			float decodeFloatRGBA25 = DecodeFloatRGBA( float4( tex2DNode4.rgb , 0.0 ) );
			float dotResult29 = dot( tex2DNode4.r , decodeFloatRGBA25 );
			float4 temp_cast_2 = (dotResult29).xxxx;
			float4 color27 = IsGammaSpace() ? float4(0.1254902,0.2235294,0.3607843,0.2) : float4(0.01444384,0.0409152,0.1070231,0.2);
			float4 lerpResult30 = lerp( lerpResult28 , temp_cast_2 , color27.a);
			float3 lerpResult13 = lerp( tex2DNode4.rgb , tex2DNode9.rgb , lerpResult30.rgb);
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float dotResult3 = dot( ase_vertexNormal , float3(0,1,0) );
			float3 lerpResult41 = lerp( lerpResult13 , float3( 0,0,0 ) , pow( ( 1.0 - dotResult3 ) , 2.57 ));
			o.Emission = lerpResult41;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
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
Node;AmplifyShaderEditor.SamplerNode;9;-679.8757,-676.9482;Inherit;True;Property;_StyleHeightmap;StyleHeightmap;1;0;Create;True;0;0;0;False;0;False;-1;301b7155c09b9694ab6042feb20620b7;e79f46d3028d82a4fa9961bcc55cc08c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;19;-183.8757,-1636.948;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;2.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;20;-555.8757,-1268.948;Inherit;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;0;False;0;False;1,0.82,-1.22;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-1248,-736;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;273a05978e066e746ad7763ce2684edb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-7.875732,-1556.948;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;23;-256,-1424;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;1;-135.8757,779.0518;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;2;-215.8757,523.0518;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-1488,496;Inherit;True;Property;_TextureSample4;Texture Sample 3;9;0;Create;True;0;0;0;False;0;False;-1;None;273a05978e066e746ad7763ce2684edb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.DecodeFloatRGBAHlpNode;25;-199.8757,-1140.948;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;176,-1456;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-416,-864;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DotProductOpNode;3;136.1243,635.0518;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-119.8757,1195.052;Inherit;False;Property;_BumpPower;BumpPower;2;0;Create;True;0;0;0;False;0;False;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;77;-1120,592;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;1056,-1552;Inherit;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;0;False;0;False;-1;None;f8f206ad6c5cece4da5d514f19cc9dc4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;81;1200,-1312;Inherit;False;Property;_DisplacementScale;DisplacementScale;11;0;Create;True;0;0;0;False;0;False;1.15;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-647.8757,-468.9482;Inherit;False;Constant;_Color2;Color 2;6;0;Create;True;0;0;0;False;0;False;0.1254902,0.2235294,0.3607843,0.2;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;28;168.1243,-1156.948;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;29;-87.87573,-932.9482;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;78;768,-1552;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;264.1243,715.0518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;488.1243,747.0518;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;2.57;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;10;88.12427,1227.052;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;168.1243,1003.052;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1376,-1520;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;30;-384,-96;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;12;440.1243,635.0518;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;40.12427,-372.9482;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;552.1243,859.0518;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;1635.699,-1486.293;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;8;-631.8757,907.0518;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;48;-1712,1168;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;63;-1408,1168;Inherit;False;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;60;-1152,1168;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;69;-1008,1120;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-1520,1552;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1008,1744;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-800,1088;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-1024,1440;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-1008,1968;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-736,1152;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;46;-752,1408;Inherit;True;Property;_TextureSampley;Texture Sample y;6;0;Create;True;0;0;0;False;0;False;-1;None;ffe80db1dd4ce4a489666675135c94ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;54;-784,1632;Inherit;True;Property;_TextureSamplex;Texture Sample x;7;0;Create;True;0;0;0;False;0;False;-1;None;ffe80db1dd4ce4a489666675135c94ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;57;-784,1856;Inherit;True;Property;_TextureSamplez;Texture Sample z;8;0;Create;True;0;0;0;False;0;False;-1;None;ffe80db1dd4ce4a489666675135c94ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.NormalizeNode;64;-544,1088;Inherit;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;70;-496,1200;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;65;-320,1408;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;66;-320,1616;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;74;-704,1280;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;71;-512,1312;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;67;-336,1808;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;31;-183.8757,971.0518;Inherit;True;Property;_RenderTexture;RenderTexture;0;0;Create;True;0;0;0;False;0;False;-1;96d0e153619eb17418b7cdf8bff3550c;273a05978e066e746ad7763ce2684edb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;41;488.1243,347.0518;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1248,-960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1136,-1008;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;273a05978e066e746ad7763ce2684edb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;75;-16,1504;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;937.5657,741.8725;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-784,-1168;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;21;-1088,-176;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;7f0aa0d8abde14e4ba5ec1ce7c5884fc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;84;1120,544;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UVShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;19;0
WireConnection;23;0;9;5
WireConnection;23;1;20;0
WireConnection;25;0;4;5
WireConnection;26;0;9;0
WireConnection;26;1;22;0
WireConnection;26;2;23;0
WireConnection;24;0;4;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;77;0;76;5
WireConnection;77;1;76;5
WireConnection;28;0;26;0
WireConnection;29;0;24;0
WireConnection;29;1;25;0
WireConnection;6;0;3;0
WireConnection;11;0;77;0
WireConnection;11;1;5;0
WireConnection;80;0;79;5
WireConnection;80;1;81;0
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;30;2;27;4
WireConnection;12;0;6;0
WireConnection;12;1;7;0
WireConnection;13;0;4;5
WireConnection;13;1;9;5
WireConnection;13;2;30;0
WireConnection;44;0;11;0
WireConnection;44;1;10;0
WireConnection;82;0;80;0
WireConnection;82;1;78;0
WireConnection;8;0;4;5
WireConnection;8;1;4;5
WireConnection;63;0;48;0
WireConnection;60;0;63;0
WireConnection;69;0;60;0
WireConnection;56;0;47;2
WireConnection;56;1;47;3
WireConnection;72;0;69;0
WireConnection;72;1;69;1
WireConnection;53;0;47;1
WireConnection;53;1;47;3
WireConnection;59;0;47;1
WireConnection;59;1;47;2
WireConnection;73;0;69;1
WireConnection;73;1;69;2
WireConnection;46;1;53;0
WireConnection;54;1;56;0
WireConnection;57;1;59;0
WireConnection;64;0;72;0
WireConnection;70;0;73;0
WireConnection;65;0;54;5
WireConnection;65;1;46;5
WireConnection;65;2;64;0
WireConnection;66;0;46;5
WireConnection;66;1;57;5
WireConnection;66;2;70;0
WireConnection;74;0;69;0
WireConnection;74;1;69;2
WireConnection;71;0;74;0
WireConnection;67;0;54;5
WireConnection;67;1;57;5
WireConnection;67;2;71;0
WireConnection;41;0;13;0
WireConnection;41;2;12;0
WireConnection;18;1;17;0
WireConnection;75;0;66;0
WireConnection;75;1;65;0
WireConnection;85;0;44;0
WireConnection;85;1;82;0
WireConnection;45;0;9;5
WireConnection;45;1;23;0
WireConnection;84;2;41;0
WireConnection;84;11;85;0
ASEEND*/
//CHKSM=48B0014AA8D7F39089BF2EB7D6E9CC57CF289163