Shader "Snake/Sanke_Player_V" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _MainPower ("MainPower", Float ) = 1
        _MainColor ("MainColor", Color) = (0.5,0.5,0.5,1)
        _RAMP ("RAMP", 2D) = "white" {}
        _SpTex ("SpTex", 2D) = "white" {}
        _Sp_Xyz ("Sp_Xyz", Vector) = (0,0,0,0)
        _Bands ("Bands", Float ) = 8
        _Gloss ("Gloss", Float ) = 0
        _SP_A_Pw ("SP_A_Pw", Float ) = 0
        _VertexOut ("VertexOut", Float ) = 1
        _Fr_color ("Fr_color", Color) = (0,0,0,1)
        _Fr_Pw ("Fr_Pw", Float ) = 1
        _Fr_Fw ("Fr_Fw", Range(0, 10)) = 10
        _Fg_Fw ("Fg_Fw", Float ) = 0
        _Fg_Pw ("Fg_Pw", Float ) = 0
        _Fg_Color ("Fg_Color", Color) = (0.5,0.5,0.5,1)
        _Fg_XYZ ("Fg_XYZ", Vector) = (0,0,0,0)
        _Fg_Width ("Fg_Width", Float ) = 0
        _ZNTex ("ZNTex", 2D) = "white" {}
        _Fg_R_Mask ("Fg_R_Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque" 
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma target 2.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _RAMP; uniform float4 _RAMP_ST;
            uniform float _MainPower;
            uniform float4 _MainColor;
            uniform float _Bands;
            uniform float4 _Sp_Xyz;
            uniform float _Gloss;
            uniform sampler2D _SpTex; 
            uniform float _SP_A_Pw;
            uniform float _VertexOut;
            uniform float4 _LG_Color;
            uniform float _Fr_Fw;
            uniform float4 _Fr_color;
            uniform float _Fr_Pw;
            uniform float _Fg_Fw;
            uniform float _Fg_Pw;
            uniform float4 _Fg_Color;
            uniform float4 _Fg_XYZ;
            uniform float _Fg_Width;
            uniform sampler2D _ZNTex; uniform float4 _ZNTex_ST;
            uniform sampler2D _Fg_R_Mask; 
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
                LIGHTING_COORDS(4,5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                v.vertex.xyz += ((_VertexOut*0.01+0.0)*1.0*v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
////// Emissive:
                float node_3891 = pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fr_Fw);
                float3 node_745 = (node_3891*_Fr_color.rgb*_Fr_Pw);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float node_3130 = 0.5*dot(lightDirection,normalDirection)+0.5;
                float2 node_8032 = float2(node_3130,node_3130);
                float4 _RAMP_var = tex2D(_RAMP,TRANSFORM_TEX(node_8032, _RAMP));
                float4 _SpTex_var = tex2D(_SpTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float node_886 = pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fg_Fw);
                float node_6093 = (node_886*0.5*dot(normalDirection,(lightDirection*_Fg_XYZ.rgb))+0.5.r);
                float4 _ZNTex_var = tex2D(_ZNTex,TRANSFORM_TEX(i.uv0, _ZNTex));
                float4 _Fg_R_Mask_var = tex2D(_Fg_R_Mask,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 finalColor = node_745 + saturate(max(saturate(max(saturate(((_MainTex_var.rgb*_MainPower*_MainColor.rgb)*_RAMP_var.rgb)),(_SpTex_var.rgb*floor(pow(dot(clamp(_Sp_Xyz.rgb,-1,1),saturate(lightDirection*normalDirection)),exp2(((clamp(_Gloss,-10,10)*10.0)+1.0))) * _Bands) / (_Bands - 1)*_SP_A_Pw*_SpTex_var.a))),(node_6093*_Fg_Pw*_Fg_Color.rgb*((_ZNTex_var.r+node_886).r*(_Fg_Width-node_6093)*node_886)*_Fg_R_Mask_var.r)));
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
}
