import {AbsoluteFill} from 'remotion';
import {C, MARGIN} from '../theme';
import {spectrumAnchors, SPEC_TICKS as TICKS} from '../world/layout';
import {Anchor} from '../ui/Anchor';
import {TopLeft} from '../ui/Heading';
import {Reveal, display, plate, text} from '../ui/Text';
import {useReveal} from '../ui/reveal';

const peakLabel = {...text(28, 700), color: C.gold};
const small = {...text(22), color: C.ice};

const Axis: React.FC = () => {
	const r = useReveal(18);
	const {axisL, axisR, ticks} = spectrumAnchors();
	return (
		<div style={{position: 'absolute', inset: 0, ...r}}>
			<div
				style={{
					position: 'absolute',
					left: axisL.x,
					top: axisL.y,
					width: axisR.x - axisL.x,
					height: 1.5,
					background: C.ice,
					opacity: 0.7,
				}}
			/>
			{ticks.map((t, n) => (
				<div key={n}>
					<div
						style={{
							position: 'absolute',
							left: t.x - 0.75,
							top: t.y,
							width: 1.5,
							height: 10,
							background: C.ice,
							opacity: 0.7,
						}}
					/>
					<Anchor x={t.x} y={t.y + 14} ay={0}>
						<div style={{...small, textShadow: 'none'}}>{TICKS[n]}</div>
					</Anchor>
				</div>
			))}
			<Anchor x={(ticks[2].x + ticks[3].x) / 2} y={ticks[2].y + 14} ay={0}>
				<div style={{...text(24, 700), color: C.ice}}>Энергия, кэВ</div>
			</Anchor>
			<Anchor x={(ticks[0].x + ticks[1].x) / 2} y={ticks[0].y + 14} ay={0}>
				<div style={{...small, fontStyle: 'italic', opacity: 0.8}}>схемалық спектр</div>
			</Anchor>
		</div>
	);
};

const PLATES = ['Зертхана: калибрлеу', 'Есептеу: Монте-Карло', 'Жоба: зерттеу сұрағы'];

export const Spectrum: React.FC = () => {
	const {cs, co} = spectrumAnchors();
	return (
		<AbsoluteFill>
			<TopLeft>
				<Reveal delay={8} style={display(56)}>
					Ядролық физикадағы мысал
				</Reveal>
			</TopLeft>
			<Anchor {...cs}>
				<Reveal delay={30} style={peakLabel}>
					Cs-137 · 661,7 кэВ
				</Reveal>
			</Anchor>
			<Anchor {...co}>
				<Reveal delay={36} style={peakLabel}>
					Co-60 · 1173,2 / 1332,5 кэВ
				</Reveal>
			</Anchor>
			<Axis />
			<div
				style={{
					position: 'absolute',
					left: MARGIN,
					right: MARGIN,
					bottom: MARGIN,
					display: 'flex',
					justifyContent: 'center',
					gap: 28,
				}}
			>
				{PLATES.map((p, n) => (
					<Reveal key={p} delay={48 + n * 8} style={{...text(26, 700), ...plate}}>
						{p}
					</Reveal>
				))}
			</div>
		</AbsoluteFill>
	);
};
