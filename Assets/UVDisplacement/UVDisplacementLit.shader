Shader "Custom/Lit/UVDisplacementLit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DisplacementTex ("Displacement Map", 2D) = "white" {}
        _DisplacementStrength ("Displacement Stength", Range(0,10)) = 0.1
        _DisplacementSpeed ("Displacement Speed", Range(0,10)) = 0.4
        _BumpMap ("Bumpmap", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _DisplacementTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_DisplacementTex;
        };

        half _Glossiness;
        half _Metallic;
        //float4 _DisplacementTex_ST;
        half _DisplacementSpeed;
        half _DisplacementStrength;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {            
            fixed4 dispTex = tex2D(_DisplacementTex, IN.uv_DisplacementTex + _Time * _DisplacementSpeed);
            fixed dispVal = (dispTex.a-0.5020f) * _DisplacementStrength;
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex + dispVal);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap + dispVal));
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
