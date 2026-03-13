"use client";
import React from "react";
import { useForm } from "react-hook-form";
import axios from "axios";
import { motion } from "framer-motion";
import { Send, Loader2 } from "lucide-react";
import { toast } from "react-hot-toast";

type FormValues = {
  nombre: string;
  email: string;
  telefono?: string;
  mensaje: string;
};

export default function ContactForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<FormValues>();

  const onSubmit = async (data: FormValues) => {
    try {
      const res = await axios.post("/api/contacto", data);
      if (res.data?.ok) {
        toast.success("¡Gracias! Tu mensaje fue enviado y te contactaremos pronto.");
        reset();
      } else {
        toast.error("No se pudo enviar el mensaje. Inténtalo nuevamente.");
      }
    } catch (err) {
      console.error("Error enviando contacto", err);
      toast.error("Ocurrió un error al enviar el mensaje. Por favor, inténtalo más tarde.");
    }
  };

  return (
    <section
      id="contacto"
      className="py-16 sm:py-24"
      aria-labelledby="contacto-title"
    >
      <div className="container">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="max-w-xl mx-auto card p-6 sm:p-8"
        >
          <h2
            id="contacto-title"
            className="text-2xl sm:text-3xl font-bold text-[var(--color-secondary)]"
          >
            Contáctanos
          </h2>
          <p className="text-[var(--color-text-muted)] mt-2">
            ¿Tienes un pedido especial o consulta? Envíanos un mensaje.
          </p>

          <form
            onSubmit={handleSubmit(onSubmit)}
            className="mt-6 space-y-4"
            noValidate
          >
            <div>
              <label htmlFor="contact-nombre" className="block text-sm font-medium text-[var(--color-text)] mb-1">
                Nombre
              </label>
              <input
                id="contact-nombre"
                type="text"
                className="input-base"
                aria-invalid={!!errors.nombre}
                aria-describedby={errors.nombre ? "nombre-error" : undefined}
                {...register("nombre", { required: "Ingresa tu nombre" })}
              />
              {errors.nombre && (
                <p id="nombre-error" className="text-xs text-[var(--color-error)] mt-1" role="alert">
                  {errors.nombre.message}
                </p>
              )}
            </div>

            <div>
              <label htmlFor="contact-email" className="block text-sm font-medium text-[var(--color-text)] mb-1">
                Email
              </label>
              <input
                id="contact-email"
                type="email"
                className="input-base"
                aria-invalid={!!errors.email}
                aria-describedby={errors.email ? "email-error" : undefined}
                {...register("email", {
                  required: "Ingresa tu email",
                  pattern: {
                    value: /[^@\s]+@[^@\s]+\.[^@\s]+/,
                    message: "Email inválido",
                  },
                })}
              />
              {errors.email && (
                <p id="email-error" className="text-xs text-[var(--color-error)] mt-1" role="alert">
                  {errors.email.message}
                </p>
              )}
            </div>

            <div>
              <label htmlFor="contact-telefono" className="block text-sm font-medium text-[var(--color-text)] mb-1">
                Teléfono <span className="text-[var(--color-text-muted)]">(opcional)</span>
              </label>
              <input
                id="contact-telefono"
                type="tel"
                className="input-base"
                {...register("telefono")}
              />
            </div>

            <div>
              <label htmlFor="contact-mensaje" className="block text-sm font-medium text-[var(--color-text)] mb-1">
                Mensaje
              </label>
              <textarea
                id="contact-mensaje"
                rows={4}
                className="input-base resize-y min-h-[100px]"
                aria-invalid={!!errors.mensaje}
                aria-describedby={errors.mensaje ? "mensaje-error" : undefined}
                {...register("mensaje", { required: "Cuéntanos tu consulta" })}
              />
              {errors.mensaje && (
                <p id="mensaje-error" className="text-xs text-[var(--color-error)] mt-1" role="alert">
                  {errors.mensaje.message}
                </p>
              )}
            </div>

            <div className="pt-2">
              <motion.button
                type="submit"
                className="btn btn-primary w-full sm:w-auto inline-flex items-center justify-center gap-2"
                disabled={isSubmitting}
                whileHover={{ scale: 1.01 }}
                whileTap={{ scale: 0.99 }}
              >
                {isSubmitting ? (
                  <>
                    <Loader2 size={18} className="animate-spin" aria-hidden />
                    Enviando...
                  </>
                ) : (
                  <>
                    <Send size={18} aria-hidden />
                    Enviar
                  </>
                )}
              </motion.button>
            </div>
          </form>
        </motion.div>
      </div>
    </section>
  );
}
