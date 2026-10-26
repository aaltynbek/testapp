import {AbsoluteFill} from 'remotion';
import {C, MARGIN} from '../theme';
import {Reveal, display, text} from '../ui/Text';

export const Hook: React.FC = () => (
	<AbsoluteFill
		style={{
			justifyContent: 'flex-end',
			alignItems: 'center',
			textAlign: 'center',
			padding: MARGIN,
		}}
	>
		<Reveal delay={10} style={display(96)}>
			<span style={{color: C.gold}}>30</span> академиялық сағат
		</Reveal>
		<Reveal delay={55} style={{...display(64, 500), color: C.gold, marginTop: 6}}>
			= 1 академиялық кредит
		</Reveal>
		<Reveal delay={70} style={{...text(26), color: C.ice, marginTop: 18}}>
			1 акад. сағат = 50 мин · ОКТ қағидалары, 23-т.
		</Reveal>
	</AbsoluteFill>
);
