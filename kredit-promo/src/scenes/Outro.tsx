import {AbsoluteFill} from 'remotion';
import {C} from '../theme';
import {Reveal, display, text} from '../ui/Text';

export const Outro: React.FC = () => (
	<AbsoluteFill style={{justifyContent: 'center', alignItems: 'center', textAlign: 'center'}}>
		<Reveal delay={8} style={display(84)}>
			Кредит — сағат емес.
		</Reveal>
		<Reveal delay={26} style={{...display(84), color: C.gold, marginTop: 8}}>
			Расталған оқу нәтижесі.
		</Reveal>
		<Reveal delay={48} style={{...text(28), color: C.ice, marginTop: 30}}>
			Жоғары мектеп педагогикасы · 2026
		</Reveal>
	</AbsoluteFill>
);
