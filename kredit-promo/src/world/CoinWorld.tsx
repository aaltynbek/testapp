import {useMemo} from 'react';
import {useCurrentFrame} from 'remotion';
import {CylinderGeometry, MeshStandardMaterial} from 'three';
import {C} from '../theme';
import {N, poseAt} from './formations';

const COINS = Array.from({length: N}, (_, i) => i);

export const CoinWorld: React.FC = () => {
	// Только useCurrentFrame — никакого useFrame: кадры детерминированы.
	const frame = useCurrentFrame();
	const geometry = useMemo(() => new CylinderGeometry(0.32, 0.32, 0.07, 48), []);
	const material = useMemo(
		() =>
			new MeshStandardMaterial({
				color: C.gold,
				metalness: 0.6,
				roughness: 0.32,
				emissive: '#2a1d00',
				emissiveIntensity: 0.6,
			}),
		[],
	);

	return (
		<>
			<fog attach="fog" args={[C.navy, 15, 40]} />
			<ambientLight intensity={0.5} />
			<directionalLight position={[6, 9, 12]} intensity={2.4} color="#FFF3D6" />
			<directionalLight position={[-9, -4, -6]} intensity={1.2} color="#8FB4FF" />
			<directionalLight position={[-6, 6, 8]} intensity={0.6} color="#FFFFFF" />
			{COINS.map((i) => {
				const {p, r, s} = poseAt(i, frame);
				return (
					<mesh
						key={i}
						geometry={geometry}
						material={material}
						position={p}
						// YXZ: rotation.y — поворот вокруг вертикали экрана уже после
						// разворота монеты к камере (rotation.x = π/2)
						rotation={[r[0], r[1], r[2], 'YXZ']}
						scale={s}
					/>
				);
			})}
		</>
	);
};
