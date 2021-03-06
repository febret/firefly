layout(points) in;
layout(line_strip, max_vertices=2) out;

uniform mat4 modelView;
uniform mat4 projection;
uniform mat4 modelViewProjection;
uniform int decimation;

// Attributes
in float attrib_data[];
in vec4 attrib_vector_data[];
#if (SIZE_MODE == 1)
    in float attrib_size[];
#endif

#if (FILTER_MODE == 1)
    in float attrib_filter[];
#endif
// Outputs
flat out float data;
out vec2 texCoord;

// Uniforms
uniform vec2 filterBounds;
uniform float pointScale;

void main(void)
{    
    if(attrib_data[0] < 300.00000) return;
    if(gl_PrimitiveIDIn % decimation != 0) return;
    
#if (FILTER_MODE == 1)
    if(attrib_filter[0] < filterBounds[0] || attrib_filter[0] > filterBounds[1]) return;
#endif

#if (SIZE_MODE == 1)
    float radius =  attrib_size[0] * pointScale;
    float v = 4.188 * pow(radius * 0.5, 3);
    data = attrib_data[0] / v;
#else
    float radius =  pointScale * 2.0;
    data = attrib_data[0];
#endif

    float halfsize = radius * 0.5;
    
    texCoord = vec2(0.0,0.0);
    gl_Position = gl_in[0].gl_Position;
    gl_Position = projection * gl_Position;
    EmitVertex();

    texCoord = vec2(1.0,1.0);
    gl_Position = gl_in[0].gl_Position + attrib_vector_data[0] * radius;
    gl_Position = projection * gl_Position;
    EmitVertex();


    EndPrimitive();
}
