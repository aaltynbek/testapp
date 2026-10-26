import {ThreeCanvas} from '@remotion/three';
import {
	AbsoluteFill,
	Audio,
	interpolate,
	Sequence,
	staticFile,
	useCurrentFrame,
	useVideoConfig,
} from 'remotion';
import {Hook} from './scenes/Hook';
import {Orbits} from './scenes/Orbits';
import {Outro} from './scenes/Outro';
import {Path} from './scenes/Path';
import {Spectrum} from './scenes/Spectrum';
import {Stacks} from './scenes/Stacks';
import {Title} from './scenes/Title';
import {C} from './theme';
import {CoinWorld} from './world/CoinWorld';
import {CAMERA_Z, FOV, SCENES, SceneId} from './world/formations';

const OVERLAYS: Record<SceneId, React.FC> = {
	hook: Hook,
	title: Title,
	path: Path,
	stacks: Stacks,
	spectrum: Spectrum,
	orbits: Orbits,
	outro: Outro,
};

export const Promo: React.FC = () => {
	const frame = useCurrentFrame();
	const {width, height, durationInFrames} = useVideoConfig();
	const fade = interpolate(frame, [durationInFrames - 15, durationInFrames - 1], [0, 1], {
		extrapolateLeft: 'clamp',
		extrapolateRight: 'clamp',
	});

	return (
		<AbsoluteFill
			style={{
				background:
					'radial-gradient(ellipse at 50% 40%, #16325A 0%, #0B1F3A 55%, #06142A 100%)',
			}}
		>
			<ThreeCanvas
				width={width}
				height={height}
				camera={{fov: FOV, position: [0, 0, CAMERA_Z], near: 0.1, far: 100}}
				gl={{antialias: true, alpha: true, preserveDrawingBuffer: true}}
			>
				<CoinWorld />
			</ThreeCanvas>
			<AbsoluteFill
				style={{
					background:
						'radial-gradient(ellipse at 50% 50%, rgba(0,0,0,0) 60%, rgba(2,8,20,0.45) 100%)',
				}}
			/>
			{SCENES.map((s) => {
				const Overlay = OVERLAYS[s.id];
				return (
					<Sequence key={s.id} from={s.from} durationInFrames={s.to - s.from} name={s.id}>
						<Overlay />
					</Sequence>
				);
			})}
			<AbsoluteFill style={{background: C.navy, opacity: fade}} />
			{/* Озвучка: Piper TTS, голос kk_KZ issai (ISSAI KazakhTTS, CC BY 4.0) — см. README */}
			<Audio src={staticFile('voiceover.mp3')} />
		</AbsoluteFill>
	);
};
