import {Composition} from 'remotion';
import {FontTest} from './FontTest';
import {Promo} from './Promo';
import {DURATION, FPS, HEIGHT, WIDTH} from './world/formations';

export const RemotionRoot: React.FC = () => (
	<>
		<Composition
			id="KreditPromo"
			component={Promo}
			durationInFrames={DURATION}
			fps={FPS}
			width={WIDTH}
			height={HEIGHT}
		/>
		<Composition
			id="FontTest"
			component={FontTest}
			durationInFrames={1}
			fps={FPS}
			width={WIDTH}
			height={HEIGHT}
		/>
	</>
);
