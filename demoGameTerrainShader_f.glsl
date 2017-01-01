// Actually wrote this shader back on shadertoy a while ago, finally found a
// good use for it :P

uniform sampler2D iChannel0;
uniform vec2 iResolution;
uniform vec2 lightPos;

const vec3 bgc = vec3(0.5, 0.7, 0.9);
const int stepA = 5;
const int steps = 256;


float sqLength(vec3 vec) {
    return (vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
}

float march(vec2 pos) {
    float time = 0.0;
    vec2 mPos = pos;
    vec2 stepVec = normalize(lightPos - pos) * float(stepA);
    float dist = distance(pos, lightPos);

    for (int i = 0; i < steps; i++) {
        if (distance(pos, mPos) >= dist) {
            break;
        }
        if (sqLength(texture2D(iChannel0, mPos.xy / iResolution.xy).xyz) == 0.0) {
            time = time + 0.2;
            // Should be lit less as it travels further through the air, but not as
            // much as going through the ground
        } else {
            time = time + 1.0;
        }
        mPos = mPos + stepVec;
    }
    return time;
}

vec4 mainImage(in vec2 fragCoord) {
  vec4 fragColor = vec4(0.0);

	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 terrain = texture2D(iChannel0, uv);
  fragColor = vec4(bgc, 1);
  if (sqLength(terrain.xyz) > 0.) {
      fragColor = terrain;
  }
  fragColor -= march(fragCoord.xy) / 100.;

  if (distance(fragCoord.xy, lightPos) < 10.0) {
      fragColor += vec4(1.0 - distance(fragCoord.xy, lightPos) / 10.);
  }

  return fragColor;
}


vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 gl_FragCoord) {
  return mainImage(gl_FragCoord);
}
