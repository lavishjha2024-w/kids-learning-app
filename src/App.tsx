import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AppProvider } from "@/context/AppContext";
import { I18nProvider } from "@/context/I18nContext";
import { CandyToastBridge } from "@/features/candy/CandyToastBridge";
import BottomNav from "@/components/BottomNav";
import BreakReminder from "@/components/BreakReminder";
import Index from "./pages/Index.tsx";
import Learn from "./pages/Learn.tsx";
import Games from "./pages/Games.tsx";
import Progress from "./pages/Progress.tsx";
import Settings from "./pages/Settings.tsx";
import ParentDashboard from "./pages/ParentDashboard.tsx";
import NotFound from "./pages/NotFound.tsx";
import GeneralKnowledge from "./pages/GeneralKnowledge.tsx";
import Scribble from "./pages/Scribble.tsx";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <I18nProvider>
      <AppProvider>
        <CandyToastBridge />
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Index />} />
            <Route path="/learn" element={<Learn />} />
            <Route path="/games" element={<Games />} />
            <Route path="/gk" element={<GeneralKnowledge />} />
            <Route path="/scribble" element={<Scribble />} />
            <Route path="/progress" element={<Progress />} />
            <Route path="/settings" element={<Settings />} />
            <Route path="/parent" element={<ParentDashboard />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
          <BottomNav />
          <BreakReminder />
        </BrowserRouter>
      </AppProvider>
    </I18nProvider>
  </QueryClientProvider>
);

export default App;
