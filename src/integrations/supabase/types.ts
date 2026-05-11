export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      drinking_log: {
        Row: {
          created_at: string
          date: string
          id: string
          note: string | null
          people_ids: string[]
          user_id: string
          wine_id: string | null
        }
        Insert: {
          created_at?: string
          date?: string
          id?: string
          note?: string | null
          people_ids?: string[]
          user_id: string
          wine_id?: string | null
        }
        Update: {
          created_at?: string
          date?: string
          id?: string
          note?: string | null
          people_ids?: string[]
          user_id?: string
          wine_id?: string | null
        }
        Relationships: []
      }
      people: {
        Row: {
          avatar: string | null
          created_at: string
          id: string
          name: string
          user_id: string
        }
        Insert: {
          avatar?: string | null
          created_at?: string
          id?: string
          name: string
          user_id: string
        }
        Update: {
          avatar?: string | null
          created_at?: string
          id?: string
          name?: string
          user_id?: string
        }
        Relationships: []
      }
      wine_appellations: {
        Row: {
          appellation_type: string | null
          country_id: string | null
          created_at: string
          id: string
          level: string
          name: string
          region_id: string | null
          sort_order: number
          sub_region_id: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          appellation_type?: string | null
          country_id?: string | null
          created_at?: string
          id?: string
          level?: string
          name: string
          region_id?: string | null
          sort_order?: number
          sub_region_id?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          appellation_type?: string | null
          country_id?: string | null
          created_at?: string
          id?: string
          level?: string
          name?: string
          region_id?: string | null
          sort_order?: number
          sub_region_id?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "wine_appellations_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "wine_countries"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wine_appellations_region_id_fkey"
            columns: ["region_id"]
            isOneToOne: false
            referencedRelation: "wine_regions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wine_appellations_sub_region_id_fkey"
            columns: ["sub_region_id"]
            isOneToOne: false
            referencedRelation: "wine_sub_regions"
            referencedColumns: ["id"]
          },
        ]
      }
      wine_colours: {
        Row: {
          created_at: string
          display_name: string
          id: string
          name: string
          sort_order: number
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          display_name: string
          id?: string
          name: string
          sort_order?: number
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          display_name?: string
          id?: string
          name?: string
          sort_order?: number
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      wine_countries: {
        Row: {
          continent: string | null
          created_at: string
          id: string
          name: string
          sort_order: number
          updated_at: string
          user_id: string
        }
        Insert: {
          continent?: string | null
          created_at?: string
          id?: string
          name: string
          sort_order?: number
          updated_at?: string
          user_id: string
        }
        Update: {
          continent?: string | null
          created_at?: string
          id?: string
          name?: string
          sort_order?: number
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      wine_regions: {
        Row: {
          country_id: string
          created_at: string
          id: string
          name: string
          sort_order: number
          updated_at: string
          user_id: string
        }
        Insert: {
          country_id: string
          created_at?: string
          id?: string
          name: string
          sort_order?: number
          updated_at?: string
          user_id: string
        }
        Update: {
          country_id?: string
          created_at?: string
          id?: string
          name?: string
          sort_order?: number
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "wine_regions_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "wine_countries"
            referencedColumns: ["id"]
          },
        ]
      }
      wine_sub_regions: {
        Row: {
          created_at: string
          id: string
          name: string
          region_id: string
          sort_order: number
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
          region_id: string
          sort_order?: number
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
          region_id?: string
          sort_order?: number
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "wine_sub_regions_region_id_fkey"
            columns: ["region_id"]
            isOneToOne: false
            referencedRelation: "wine_regions"
            referencedColumns: ["id"]
          },
        ]
      }
      wines: {
        Row: {
          alcohol_pct: number | null
          appellation: string | null
          ausbau_terroir: string | null
          cl: number | null
          colour: string | null
          country: string | null
          country_id: string | null
          created_at: string
          description: string | null
          dosage: string | null
          drink_by: number | null
          id: string
          label_photo_url: string | null
          notes: string | null
          occasion: string | null
          price_chf: number | null
          producer: string | null
          purchased_from: string | null
          quantity: number | null
          rating: number | null
          ready_from: number | null
          region: string | null
          region_id: string | null
          residual_sugar_gl: number | null
          sub_region: string | null
          updated_at: string
          user_id: string
          variety: string | null
          vintage: string | null
        }
        Insert: {
          alcohol_pct?: number | null
          appellation?: string | null
          ausbau_terroir?: string | null
          cl?: number | null
          colour?: string | null
          country?: string | null
          country_id?: string | null
          created_at?: string
          description?: string | null
          dosage?: string | null
          drink_by?: number | null
          id?: string
          label_photo_url?: string | null
          notes?: string | null
          occasion?: string | null
          price_chf?: number | null
          producer?: string | null
          purchased_from?: string | null
          quantity?: number | null
          rating?: number | null
          ready_from?: number | null
          region?: string | null
          region_id?: string | null
          residual_sugar_gl?: number | null
          sub_region?: string | null
          updated_at?: string
          user_id: string
          variety?: string | null
          vintage?: string | null
        }
        Update: {
          alcohol_pct?: number | null
          appellation?: string | null
          ausbau_terroir?: string | null
          cl?: number | null
          colour?: string | null
          country?: string | null
          country_id?: string | null
          created_at?: string
          description?: string | null
          dosage?: string | null
          drink_by?: number | null
          id?: string
          label_photo_url?: string | null
          notes?: string | null
          occasion?: string | null
          price_chf?: number | null
          producer?: string | null
          purchased_from?: string | null
          quantity?: number | null
          rating?: number | null
          ready_from?: number | null
          region?: string | null
          region_id?: string | null
          residual_sugar_gl?: number | null
          sub_region?: string | null
          updated_at?: string
          user_id?: string
          variety?: string | null
          vintage?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "wines_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "wine_countries"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_region_id_fkey"
            columns: ["region_id"]
            isOneToOne: false
            referencedRelation: "wine_regions"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
