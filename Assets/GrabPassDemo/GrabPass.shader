Shader "Unlit/GrabPass"
{
    Properties
    {
		[PerRendererData]
        _MainTex ("Texture", 2D) = "white" {}
		_DisplacementTex("Displacement Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_DispPower ("Displacement", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"
		"Queue" = "Transparent"
		}
        Blend Off
		
		GrabPass { "_GrabTex" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 grabUv : TECTOORD1;
				float4 grabPos : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _GrabTex, _DisplacementTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			float _DispPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 displos = tex2D(_DisplacementTex, i.uv);
				float2 offset = float2(-displos.x, displos.y) * _DispPower * displos.a;
				//offset = mul(unity_ObjectToWorld, offset);
				fixed4 grabColor = tex2D(_GrabTex, i.grabPos.xy + offset);
				fixed4 texColor = tex2D(_MainTex, i.uv + offset) * _Color;
				fixed s = step(grabColor, 0.5);
				fixed4 resultColor = s*(2*texColor*grabColor) + (1 - s) * (1 - 2 * (1 - texColor) * (1 - grabColor));
				resultColor = lerp(grabColor, resultColor, texColor.a);
				return resultColor;
            }
            ENDCG
        }
    }
}
