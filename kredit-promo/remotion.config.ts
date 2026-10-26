import {Config} from '@remotion/cli/config';

Config.setVideoImageFormat('jpeg');
Config.setChromiumOpenGlRenderer('angle'); // без этого WebGL в headless Chrome может не отрисоваться

// Если Remotion не может скачать свой Chrome Headless Shell (офлайн/прокси),
// укажите готовый бинарник: REMOTION_BROWSER=/path/to/chrome-headless-shell npm run render
if (process.env.REMOTION_BROWSER) {
	Config.setBrowserExecutable(process.env.REMOTION_BROWSER);
}
